#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: variants-pair
requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}

inputs:
    tumor_bam:
       type: File
       secondaryFiles:
           - .bai
    normal_bam:
       type: File
       secondaryFiles:
           - .bai
    bed: File
    normal_sample_name: string
    tumor_sample_name: string
    dbsnp:
        type: File
        secondaryFiles:
            - .idx
    cosmic:
        type: File
        secondaryFiles:
            - .idx
    mutect_dcov: int
    mutect_rf: string[]
    refseq: File
    hotspot_vcf: string
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
    facets_snps: File
    complex_nn: float
    complex_tn: float
outputs:
    combine_vcf:
        type: File
        outputSource: tabix_index/tabix_output_file
        secondaryFiles:
        - .tbi
    annotate_vcf:
        type: File
        outputSource: annotate/annotate_vcf_output_file
    snp_pileup:
        type: File
        outputSource: call_variants/snp_pileup
    mutect_vcf:
        type: File
        outputSource: call_variants/mutect_vcf
    mutect_callstats:
        type: File
        outputSource: call_variants/mutect_callstats
    vardict_vcf:
        type: File
        outputSource: call_variants/vardict_vcf
    vardict_norm_vcf:
        type: File
        outputSource: filtering/vardict_vcf_filtering_output
        secondaryFiles:
            - .tbi
    mutect_norm_vcf:
        type: File
        outputSource: filtering/mutect_vcf_filtering_output
        secondaryFiles:
            - .tbi
steps:
    normal_index:
        run: ../../tools/cmo-utils/1.9.15/cmo-index.cwl
        in:
            bam: normal_bam
        out: [bam_indexed]
    tumor_index:
        run: ../../tools/cmo-utils/1.9.15/cmo-index.cwl
        in:
            bam: tumor_bam
        out: [bam_indexed]
    call_variants:
        in:
            tumor_bam: tumor_index/bam_indexed
            normal_bam: normal_index/bam_indexed
            ref_fasta: ref_fasta
            normal_sample_name: normal_sample_name
            tumor_sample_name: tumor_sample_name
            dbsnp: dbsnp
            cosmic: cosmic
            mutect_dcov: mutect_dcov
            mutect_rf: mutect_rf
            bed: bed
            refseq: refseq
            facets_snps: facets_snps
        out: [ vardict_vcf, mutect_vcf, mutect_callstats, snp_pileup]
        run:
            class: Workflow
            id: call-variants
            inputs:
                normal_bam: File
                tumor_bam: File
                ref_fasta: File
                normal_sample_name: string
                tumor_sample_name: string
                dbsnp: File
                cosmic: File
                mutect_dcov: int
                mutect_rf: string[]
                bed: File
                refseq: File #file of refseq genes...
                facets_snps: File
            outputs:
                mutect_vcf:
                    type: File
                    outputSource: mutect/output
                mutect_callstats:
                    type: File
                    outputSource: mutect/callstats_output
                vardict_vcf:
                    type: File
                    outputSource: vardict/output
                snp_pileup:
                    type: File
                    outputSource: snp_pileup/out_file
            steps:
                snp_pileup:
                    run: ../../tools/htstools/0.1.1/snp-pileup.cwl
                    in:
                        normal_bam: normal_bam
                        tumor_bam: tumor_bam
                        vcf: facets_snps
                        output_file:
                            valueFrom: ${ return inputs.normal_bam.basename.replace(".bam", "") + "__" + inputs.tumor_bam.basename.replace(".bam", "") + ".dat.gz"; }
                        count_orphans:
                            valueFrom: ${ return true; }
                        gzip:
                            valueFrom: ${ return true; }
                        pseudo_snps:
                            default: "50"
                    out: [out_file]
                vardict:
                    run: ../../tools/vardict/1.5.1/vardict.cwl
                    in:
                        G: ref_fasta
                        b: tumor_bam
                        b2: normal_bam
                        N: tumor_sample_name
                        N2: normal_sample_name
                        bedfile: bed
                        C:
                            default: true
                        D:
                            default: false
                        x:
                            default: '2000'
                        H:
                            default: false
                        th:
                            default: '4'
                        E:
                            default: '3'
                        i:
                            default: false
                        hh:
                            default: false
                        f:
                            default: '0.01'
                        c:
                            default: '1'
                        Q:
                            default: '20'
                        X:
                            default: '5'
                        z:
                            default: '1'
                        S:
                            default: '2'
                        p:
                            default: false
                        q:
                            default: '20'
                        t:
                            default: false
                        vcf:
                            valueFrom: ${ return inputs.b.basename.replace(".bam", ".") + inputs.b2.basename.replace(".bam", ".vardict.vcf") }
                    out: [output]
                mutect:
                    run: ../../tools/mutect/1.1.4/mutect.cwl
                    in:
                        reference_sequence: ref_fasta
                        dbsnp: dbsnp
                        cosmic: cosmic
                        input_file_normal: normal_bam
                        input_file_tumor: tumor_bam
                        read_filter: mutect_rf
                        downsample_to_coverage: mutect_dcov
                        intervals: bed
                        vcf:
                            valueFrom: ${ return inputs.input_file_tumor.basename.replace(".bam",".") + inputs.input_file_normal.basename.replace(".bam", ".mutect.vcf") }
                        out:
                            valueFrom: ${ return inputs.input_file_tumor.basename.replace(".bam",".") + inputs.input_file_normal.basename.replace(".bam", ".mutect.txt") }
                    out: [output, callstats_output]
    filtering:
        in:
            complex_nn: complex_nn
            complex_tn: complex_tn
            normal_bam: normal_bam
            tumor_bam: tumor_bam
            mutect_vcf: call_variants/mutect_vcf
            mutect_callstats: call_variants/mutect_callstats
            vardict_vcf: call_variants/vardict_vcf
            tumor_sample_name: tumor_sample_name
            hotspot_vcf: hotspot_vcf
            ref_fasta: ref_fasta
        out: [vardict_vcf_filtering_output, mutect_vcf_filtering_output]
        run:
            class: Workflow
            id: filtering
            inputs:
                complex_nn: float
                complex_tn: float
                normal_bam: File
                tumor_bam: File
                mutect_vcf: File
                mutect_callstats: File
                vardict_vcf: File
                hotspot_vcf: string
                tumor_sample_name: string
                ref_fasta: File
            outputs:
                mutect_vcf_filtering_output:
                    type: File
                    outputSource: mutect_filtering_step/vcf
                    secondaryFiles:
                        - .tbi
                vardict_vcf_filtering_output:
                    type: File
                    outputSource: vardict_filtering_step/vcf
                    secondaryFiles:
                        - .tbi
            steps:
                mutect_filtering_step:
                    run: ../../tools/basic-filtering.mutect/0.3/basic-filtering.mutect.cwl
                    in:
                        inputVcf: mutect_vcf
                        inputTxt: mutect_callstats
                        tsampleName: tumor_sample_name
                        hotspotVcf: hotspot_vcf
                        refFasta: ref_fasta
                    out: [vcf]
                vardict_complex_filtering_step:
                    run: ../../tools/basic-filtering.complex/0.3/basic-filtering.complex.cwl
                    in:
                        nrm_noise: complex_nn
                        tum_noise: complex_tn
                        inputVcf: vardict_vcf
                        normal_bam: normal_bam
                        tumor_bam: tumor_bam
                        tumor_id: tumor_sample_name
                        output_vcf:
                            valueFrom: ${ return inputs.inputVcf.basename.replace(".vcf", ".complex_filtered.vcf"); }
                    out: [vcf]
                vardict_filtering_step:
                    run: ../../tools/basic-filtering.vardict/0.3/basic-filtering.vardict.cwl
                    in:
                        inputVcf: vardict_complex_filtering_step/vcf
                        tsampleName: tumor_sample_name
                        hotspotVcf: hotspot_vcf
                        refFasta: ref_fasta
                    out: [vcf]

    create_vcf_file_array:
        in:
            vcf_vardict: filtering/vardict_vcf_filtering_output
            vcf_mutect: filtering/mutect_vcf_filtering_output
        out: [ vcf_files ]
        run:
            class: ExpressionTool
            id: create-vcf-file-array
            requirements:
                - class: InlineJavascriptRequirement
            inputs:
                vcf_vardict:
                    type: File
                    secondaryFiles:
                        - .tbi
                vcf_mutect:
                    type: File
                    secondaryFiles:
                        - .tbi
            outputs:
                vcf_files:
                    type:
                        type: array
                        items: File
                    secondaryFiles:
                        - .tbi
            expression: "${ var project_object = {};
                project_object['vcf_files'] = [ inputs.vcf_vardict, inputs.vcf_mutect];
                return project_object;
            }"

    concat:
        run: ../../tools/bcftools.concat/1.9/bcftools.concat.cwl
        in:
            vcf_files_tbi: create_vcf_file_array/vcf_files
            tumor_sample_name: tumor_sample_name
            normal_sample_name: normal_sample_name
            allow_overlaps:
                valueFrom: ${ return true; }
            rm_dups:
                valueFrom: ${ return "all"; }
            output_type:
                valueFrom: ${ return "z"; }
            output:
                valueFrom: ${ return inputs.tumor_sample_name + "." + inputs.normal_sample_name + ".combined-variants.vcf.gz" }
        out: [concat_vcf_output_file]
    tabix_index:
        run: ../../tools/tabix/1.9/tabix.cwl
        in:
            input_vcf: concat/concat_vcf_output_file
            preset:
                valueFrom: ${ return "vcf"; }
        out: [tabix_output_file]
    annotate:
        run: ../../tools/bcftools.annotate/1.9/bcftools.annotate.cwl
        in:
            annotations: filtering/mutect_vcf_filtering_output
            tumor_sample_name: tumor_sample_name
            normal_sample_name: normal_sample_name
            columns:
                valueFrom: ${ return ["INFO/FAILURE_REASON"]; }
            mark_sites:
                valueFrom: ${ return "+set=MuTect"; }
            vcf_file_tbi: tabix_index/tabix_output_file
            output:
                valueFrom: ${ return inputs.tumor_sample_name + "." + inputs.normal_sample_name + ".annotate-variants.vcf" }
        out: [annotate_vcf_output_file]
