#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: maf-processing-pair
requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}

inputs:

    tumor:
        type:
            type: record
            fields:
                CN: string
                LB: string
                ID: string
                PL: string
                PU: string[]
                R1: File[]
                R2: File[]
                zR1: File[]
                zR2: File[]
                bam: File[]
                RG_ID: string[]
                adapter: string
                adapter2: string
                bwa_output: string
    normal:
        type:
            type: record
            fields:
                CN: string
                LB: string
                ID: string
                PL: string
                PU: string[]
                R1: File[]
                R2: File[]
                zR1: File[]
                zR2: File[]
                bam: File[]
                RG_ID: string[]
                adapter: string
                adapter2: string
                bwa_output: string

    bams:
        type: File[]
        secondaryFiles:
            - ^.bai
    annotate_vcf: File
    normal_sample_name: string
    tumor_sample_name: string
    genome: string
    ref_fasta:
        type: File
        secondaryFiles:
          - .amb
          - .ann
          - .bwt
          - .pac
          - .sa
          - .fai
          - ^.dict
    vep_path: string
    custom_enst: string
    exac_filter:
        type: File
        secondaryFiles:
            - .tbi
    vep_data: string
    curated_bams:
        type: File[]
        secondaryFiles:
            - ^.bai
    hotspot_list: string

outputs:
    maf:
        type: File
        outputSource: ngs_filters/output
    portal_fillout:
        type: File
        outputSource: fillout_tumor_normal/portal_fillout
steps:
    create_pairing_file:
        in:
            tumor: tumor
            normal: normal
            echoString:
                valueFrom: ${ return inputs.normal.ID + "\t" + inputs.tumor.ID; }
            output_filename:
                valueFrom: ${ return "tn_pairing_file.txt"; }
        out: [ pairfile ]
        run:
            class: CommandLineTool
            baseCommand: ['echo', '-e']
            id: create_TN_pair
            stdout: $(inputs.output_filename)
            requirements:
                InlineJavascriptRequirement: {}
                MultipleInputFeatureRequirement: {}
                DockerRequirement:
                    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/cmo-utils:1.9.15
            inputs:
                tumor:
                    type:
                        type: record
                        fields:
                            ID: string
                normal:
                    type:
                        type: record
                        fields:
                            ID: string
                echoString:
                    type: string
                    inputBinding:
                        position: 1
                output_filename: string
            outputs:
                pairfile:
                    type: stdout

    vcf2maf:
        run: ../../tools/vcf2maf/1.6.17/vcf2maf.cwl
        in:
            input_vcf: annotate_vcf
            tumor_id: tumor_sample_name
            vcf_tumor_id: tumor_sample_name
            normal_id: normal_sample_name
            vcf_normal_id: normal_sample_name
            ncbi_build: genome
            filter_vcf: exac_filter
            vep_data: vep_data
            ref_fasta: ref_fasta
            vep_path: vep_path
            custom_enst: custom_enst
            retain_info:
                default: "set,TYPE,FAILURE_REASON,MSI,MSILEN,SSF,LSEQ,RSEQ,STATUS,VSB"
            retain_fmt:
                default: "QUAL,BIAS,HIAF,PMEAN,PSTD,ALD,RD,NM,MQ,IS"
            output_maf:
                valueFrom: ${ return inputs.tumor_id + "." + inputs.normal_id + ".combined-variants.vep.maf" }
        out: [output]

    remove_variants:
        run: ../../tools/remove-variants/0.1.1/remove-variants.cwl
        in:
            inputMaf: vcf2maf/output
            outputMaf:
                valueFrom: ${ return inputs.inputMaf.basename.replace(".vep.maf", ".vep.rmv.maf") }
        out: [maf]

    fillout_tumor_normal:
        run: ../../tools/cmo-utils/1.9.15/cmo-fillout.cwl
        in:
            pairing: create_pairing_file/pairfile
            maf: remove_variants/maf
            bams: bams
            ref_fasta: ref_fasta
            output_format:
                default: "1"
        out: [fillout_out, portal_fillout]

    fillout_second:
        in:
            maf: fillout_tumor_normal/portal_fillout
            ref_fasta: ref_fasta
            curated_bams: curated_bams
        out: [fillout_curated_bams]
        run:
            class: Workflow
            id: fillout_second
            inputs:
                maf: File
                ref_fasta:
                  type: File
                  secondaryFiles:
                    - .amb
                    - .ann
                    - .bwt
                    - .pac
                    - .sa
                    - .fai
                    - ^.dict
                curated_bams: File[]
            outputs:
                fillout_curated_bams:
                    type: File
                    outputSource: fillout_curated_bams_step/fillout_out
            steps:
                fillout_curated_bams_step:
                    run: ../../tools/cmo-utils/1.9.15/cmo-fillout.cwl
                    in:
                        maf: maf
                        bams: curated_bams
                        ref_fasta: ref_fasta
                        output_format:
                            default: "1"
                        output:
                            valueFrom: ${ return inputs.maf.basename.replace(".maf", ".curated.fillout"); }
                    out: [fillout_out]

    ngs_filters:
        run: ../../tools/ngs-filters/1.4/ngs-filters.cwl
        in:
            tumor_sample_name: tumor_sample_name
            normal_sample_name: normal_sample_name
            inputMaf: fillout_tumor_normal/portal_fillout
            outputMaf:
                valueFrom: ${ return inputs.tumor_sample_name + "." + inputs.normal_sample_name + ".muts.maf" }
            NormalPanelMaf: fillout_second/fillout_curated_bams
            inputHSP: hotspot_list
        out: [output]
