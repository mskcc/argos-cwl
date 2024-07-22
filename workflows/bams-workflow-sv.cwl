#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: pair-workflow-sv
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  bed_file:
    type: File

  db_files:
    type:
      type: record
      fields:
        refseq: File
        vep_path: string
        custom_enst: string
        vep_data: string
        hotspot_list: string
        hotspot_list_maf: File
        delly_exclude: File
        hotspot_vcf: string
        facets_snps: File
        bait_intervals: File
        target_intervals: File
        fp_intervals: File
        fp_genotypes: File
        conpair_markers: string
        conpair_markers_bed: string
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
  mouse_fasta:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  hapmap:
    type: File
    secondaryFiles:
      - .idx
  dbsnp:
    type: File
    secondaryFiles:
      - .idx
  indels_1000g:
    type: File
    secondaryFiles:
      - .idx
  snps_1000g:
    type: File
    secondaryFiles:
      - .idx
  cosmic:
    type: File
    secondaryFiles:
      - .idx
  exac_filter:
    type: File
    secondaryFiles:
      - .tbi
  curated_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
  runparams:
    type:
      type: record
      fields:
        abra_scratch: string
        covariates: string[]
        emit_original_quals: boolean
        genome: string
        intervals: string[]
        mutect_dcov: int
        mutect_rf: string[]
        num_cpu_threads_per_data_thread: int
        num_threads: int
        tmp_dir: string
        complex_tn: float
        complex_nn: float
        delly_type: string[]
        project_prefix: string
        assay: string
        pi: string
        pi_email: string
        opt_dup_pix_dist: string
        abra_ram_min: int
        gatk_jar_path: string
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

outputs:

  # bams
  normal_bam:
    type: File
    secondaryFiles:
      - ^.bai
    outputSource: format_output/normal_bam
  tumor_bam:
    type: File
    secondaryFiles:
      - ^.bai
    outputSource: format_output/tumor_bam

  # qual metrics
  qual_metrics:
    type: File[]
    outputSource: parallel_printreads/qual_metrics
  qual_pdf:
    type: File[]
    outputSource: parallel_printreads/qual_pdf

  # vcf
  mutect_vcf:
    type: File
    outputSource: variant_calling/mutect_vcf
  mutect_callstats:
    type: File
    outputSource: variant_calling/mutect_callstats
  vardict_vcf:
    type: File
    outputSource: variant_calling/vardict_vcf
  combine_vcf:
    type: File
    outputSource: variant_calling/combine_vcf
    secondaryFiles:
      - .tbi
  annotate_vcf:
    type: File
    outputSource: variant_calling/annotate_vcf
  # norm vcf
  vardict_norm_vcf:
    type: File
    outputSource: variant_calling/vardict_norm_vcf
    secondaryFiles:
      - .tbi
  mutect_norm_vcf:
    type: File
    outputSource: variant_calling/mutect_norm_vcf
    secondaryFiles:
      - .tbi

  # snp_pileup
  snp_pileup:
    type: File
    outputSource: variant_calling/snp_pileup
  # structural variants
  merged_file_unfiltered:
    type: File
    outputSource: structural_variants/merged_file_unfiltered
  merged_file:
    type: File
    outputSource: structural_variants/merged_file
  maf_file:
    type: File
    outputSource: structural_variants/maf_file
  portal_file:
    type: File
    outputSource: structural_variants/portal_file

  # maf
  maf:
    type: File
    outputSource: maf_processing/maf

  # info

  genome:
    type: string
    outputSource: format_output/genome
  assay:
    type: string
    outputSource: format_output/assay
  pi:
    type: string
    outputSource: format_output/pi
  project_prefix:
    type: string
    outputSource: format_output/project_prefix
  pi_email:
    type: string
    outputSource: format_output/pi_email
  normal_sample_name:
    type: string
    outputSource: format_output/normal_sample_name
  tumor_sample_name:
    type: string
    outputSource: format_output/tumor_sample_name

steps:

  create_bam_array:
    in:
        tumor: tumor
        normal: normal
        bam_tumor:
            valueFrom: ${ return inputs.tumor.bam[0]; }
        bam_normal:
            valueFrom: ${ return inputs.normal.bam[0]; }
    out: [ bams, bam_tumor, bam_normal ]
    run:
        class: ExpressionTool
        id: create-bam-array
        requirements:
            - class: InlineJavascriptRequirement
        inputs:
            bam_tumor: File
            bam_normal: File
        outputs:
            bams:
                type: File[]
            bam_tumor: File
            bam_normal: File
        expression: "${
            var project_object = {};
            project_object['bams'] = [ inputs.bam_tumor, inputs.bam_normal ];
            project_object['bam_tumor'] = inputs.bam_tumor;
            project_object['bam_normal'] = inputs.bam_normal; 
            return project_object;
        }"
            
  index_bams:
      run: ../tools/cmo-utils/1.9.15/cmo-index.cwl
      in:
          bam: create_bam_array/bams
      scatter: [bam]
      scatterMethod: dotproduct
      out: [bam_indexed]

  gatk_base_recalibrator:
      run: ../tools/gatk.BaseRecalibrator/3.3-0/gatk.BaseRecalibrator.cwl
      in:
          runparams: runparams
          reference_sequence: ref_fasta
          input_file: index_bams/bam_indexed
          dbsnp: dbsnp
          hapmap: hapmap
          indels_1000g: indels_1000g
          snps_1000g: snps_1000g
          knownSites:
              valueFrom: ${return [inputs.dbsnp,inputs.hapmap, inputs.indels_1000g, inputs.snps_1000g]}
          covariate:
              valueFrom: ${ return inputs.runparams.covariates }
          out:
              valueFrom: ${ return "recal.matrix"; }
          read_filter:
            valueFrom: ${ return ["BadCigar"]; }
      out: [recal_matrix]

  parallel_printreads:
      in:
          input_file: index_bams/bam_indexed
          reference_sequence: ref_fasta
          BQSR: gatk_base_recalibrator/recal_matrix
      out: [out,qual_metrics,qual_pdf]
      scatter: [input_file]
      scatterMethod: dotproduct
      run:
          class: Workflow
          id: parallel_printreads
          inputs:
              input_file: File
              reference_sequence: File
              BQSR: File
          outputs:
              out:
                  type: File
                  secondaryFiles:
                      - ^.bai
                  outputSource: gatk_print_reads/out_bam
              qual_metrics:
                  type: File
                  outputSource: quality_metrics/qual_file
              qual_pdf:
                  type: File
                  outputSource: quality_metrics/qual_hist
          steps:
              gatk_print_reads:
                  run: ../tools/gatk.PrintReads/3.3-0/gatk.PrintReads.cwl
                  in:
                      reference_sequence: reference_sequence
                      BQSR: BQSR
                      input_file: input_file
                      num_cpu_threads_per_data_thread:
                          valueFrom: ${ return "5"; }
                      emit_original_quals:
                          valueFrom: ${ return true; }
                      baq:
                          valueFrom: ${ return ['RECALCULATE'];}
                      out:
                          valueFrom: ${ return inputs.input_file.basename.replace(".bam", ".printreads.bam");}
                  out: [out_bam]
              quality_metrics:
                  run: ../tools/picard.CollectMultipleMetrics/2.9/picard.CollectMultipleMetrics.cwl
                  in:
                    I: gatk_print_reads/out_bam
                    REFERENCE_SEQUENCE: reference_sequence
                    PROGRAM:
                      valueFrom: ${return ["null","MeanQualityByCycle"]}
                    O:
                      valueFrom: ${ return inputs.I.basename.replace(".bam", ".qmetrics")}
                  out: [qual_file, qual_hist]

  variant_calling:
    run: ../modules/pair/variant-calling-pair.cwl
    in:
        runparams: runparams
        db_files: db_files
        bams: parallel_printreads/out
        tumor: tumor
        normal: normal
        bed: bed_file
        normal_bam:
            valueFrom: ${ return inputs.bams[1]; }
        tumor_bam:
            valueFrom: ${ return inputs.bams[0]; }
        normal_sample_name:
            valueFrom: ${ return inputs.normal.ID; }
        tumor_sample_name:
            valueFrom: ${ return inputs.tumor.ID; }
        dbsnp: dbsnp
        cosmic: cosmic
        mutect_dcov:
            valueFrom: ${ return inputs.runparams.mutect_dcov }
        mutect_rf:
            valueFrom: ${ return inputs.runparams.mutect_rf }
        refseq:
            valueFrom: ${ return inputs.db_files.refseq }
        hotspot_vcf:
            valueFrom: ${ return inputs.db_files.hotspot_vcf }
        ref_fasta: ref_fasta
        facets_snps:
            valueFrom: ${ return inputs.db_files.facets_snps }
        complex_tn:
            valueFrom: ${ return inputs.runparams.complex_tn; }
        complex_nn:
            valueFrom: ${ return inputs.runparams.complex_nn; }
    out: [combine_vcf, annotate_vcf, snp_pileup, mutect_vcf, mutect_callstats, vardict_vcf, vardict_norm_vcf, mutect_norm_vcf]

  structural_variants:
    run: ../modules/pair/structural-variants-pair.cwl
    in:
        runparams: runparams
        db_files: db_files
        exac_filter: exac_filter
        tumor: tumor
        normal: normal
        bams: parallel_printreads/out
        normal_bam:
            valueFrom: ${ return inputs.bams[1]; }
        tumor_bam:
            valueFrom: ${ return inputs.bams[0]; }
        genome:
            valueFrom: ${ return inputs.runparams.genome }
        normal_sample_name:
            valueFrom: ${ return inputs.normal.ID; }
        tumor_sample_name:
            valueFrom: ${ return inputs.tumor.ID; }
        ref_fasta: ref_fasta
        vep_path:
            valueFrom: ${ return inputs.db_files.vep_path }
        custom_enst:
            valueFrom: ${ return inputs.db_files.custom_enst }
        vep_data:
            valueFrom: ${ return inputs.db_files.vep_data }
        delly_exclude:
            valueFrom: ${ return inputs.db_files.delly_exclude }
        delly_type:
            valueFrom: ${ return inputs.runparams.delly_type; }
    out: [delly_sv,delly_filtered_sv,merged_file,merged_file_unfiltered,maf_file,portal_file]
  maf_processing:
    run: ../modules/pair/maf-processing-pair.cwl
    in:
        runparams: runparams
        db_files: db_files
        annotate_vcf: variant_calling/annotate_vcf
        tumor: tumor
        normal: normal
        bams: parallel_printreads/out
        genome:
            valueFrom: ${ return inputs.runparams.genome }
        ref_fasta: ref_fasta
        vep_path:
            valueFrom: ${ return inputs.db_files.vep_path }
        custom_enst:
            valueFrom: ${ return inputs.db_files.custom_enst }
        exac_filter: exac_filter
        vep_data:
            valueFrom: ${ return inputs.db_files.vep_data }
        normal_sample_name:
            valueFrom: ${ return inputs.normal.ID; }
        tumor_sample_name:
            valueFrom: ${ return inputs.tumor.ID; }
        curated_bams: curated_bams
        hotspot_list:
            valueFrom: ${ return inputs.db_files.hotspot_list }
    out: [maf,portal_fillout]
  format_output:
    run: ../tools/format-output/pair-output.cwl
    in:
      runparams: runparams
      pair:
        source: [tumor, normal]
        linkMerge: merge_flattened
      bams: parallel_printreads/out
    out: [ genome, assay, pi, pi_email, project_prefix, normal_sample_name, tumor_sample_name, normal_bam, tumor_bam ]
