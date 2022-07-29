#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: project-workflow-sv
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
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
        facets_pcval: int
        facets_cval: int
        abra_ram_min: int
        scripts_bin: string
        gatk_jar_path: string
  tumors:
    type:
      type: array
      items:
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
  normals:
    type:
      type: array
      items:
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


  # bams & metrics
  normal_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: pair_process/normal_bam
  tumor_bams:
    type:
      type: array
      items: File
    secondaryFiles:
      - ^.bai
    outputSource: pair_process/tumor_bam
  clstats1:
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File
    outputSource: pair_process/clstats1
  clstats2:
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File
    outputSource: pair_process/clstats2
  md_metrics:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: pair_process/md_metrics
  # vcf
  mutect_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/mutect_vcf
  mutect_callstats:
    type:
      type: array
      items: File
    outputSource: pair_process/mutect_callstats
  vardict_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/vardict_vcf
  combine_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/combine_vcf
    secondaryFiles:
    - .tbi
  annotate_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/annotate_vcf
  # norm vcf
  vardict_norm_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/vardict_norm_vcf
    secondaryFiles:
      - .tbi
  mutect_norm_vcf:
    type:
      type: array
      items: File
    outputSource: pair_process/mutect_norm_vcf
    secondaryFiles:
      - .tbi
  # snp_pileup
  snp_pileup:
    type: File[]
    outputSource: pair_process/snp_pileup
  # structural variants
  merged_file_unfiltered:
    type: File[]
    outputSource: pair_process/merged_file_unfiltered
  merged_file:
    type: File[]
    outputSource: pair_process/merged_file
  maf_file:
    type: File[]
    outputSource: pair_process/maf_file
  portal_file:
    type: File[]
    outputSource: pair_process/portal_file
  # maf
  maf:
    type: File[]
    outputSource: pair_process/maf
  # qc
  qc_pdf:
    type: File
    outputSource: generate_qc/qc_pdf
  consolidated_results:
    type: Directory
    outputSource: generate_qc/consolidated_results

steps:

  pair_process:
    run: workflows/pair-workflow-sv.cwl
    in:
      db_files: db_files
      runparams: runparams
      hapmap: hapmap
      dbsnp: dbsnp
      indels_1000g: indels_1000g
      snps_1000g: snps_1000g
      exac_filter: exac_filter
      curated_bams: curated_bams
      cosmic: cosmic
      tumor: tumors
      normal: normals
      ref_fasta: ref_fasta
      mouse_fasta: mouse_fasta
    out: [normal_bam,tumor_bam,clstats1,clstats2,md_metrics,as_metrics,hs_metrics,insert_metrics,insert_pdf,per_target_coverage,qual_metrics,qual_pdf,doc_basecounts,gcbias_pdf,gcbias_metrics,gcbias_summary,conpair_pileups,mutect_vcf,mutect_callstats,vardict_vcf,combine_vcf,annotate_vcf,vardict_norm_vcf,mutect_norm_vcf,snp_pileup,merged_file_unfiltered,merged_file,maf_file,portal_file,maf,genome,assay,pi,pi_email,project_prefix,normal_sample_name,tumor_sample_name]
    scatter: [tumor, normal]
    scatterMethod: dotproduct

  generate_qc:
    run: modules/project/generate-qc-sv.cwl
    in:
      db_files: db_files
      fp_genotypes:
        valueFrom: ${ return inputs.db_files.fp_genotypes }
      hotspot_list_maf:
        valueFrom: ${ return inputs.db_files.hotspot_list_maf }
      conpair_markers:
        valueFrom: ${ return inputs.db_files.conpair_markers }
      normal_bams: pair_process/normal_bam
      tumor_bams: pair_process/tumor_bam
      normal_sample_names: pair_process/normal_sample_name
      tumor_sample_names: pair_process/tumor_sample_name
      genome_list: pair_process/genome
      assay_list: pair_process/assay
      pi_list: pair_process/pi
      pi_email_list: pair_process/pi_email
      project_prefix_list: pair_process/project_prefix
      genome:
        valueFrom: ${ return inputs.genome_list[0]; }
      assay:
        valueFrom: ${ return inputs.assay_list[0]; }
      pi:
        valueFrom: ${ return inputs.pi_list[0]; }
      pi_email:
        valueFrom: ${ return inputs.pi_email_list[0]; }
      project_prefix:
        valueFrom: ${ return inputs.project_prefix_list[0]; }
      ref_fasta: ref_fasta
      md_metrics: pair_process/md_metrics
      hs_metrics: pair_process/hs_metrics
      insert_metrics: pair_process/insert_metrics
      per_target_coverage: pair_process/per_target_coverage
      qual_metrics: pair_process/qual_metrics
      doc_basecounts: pair_process/doc_basecounts
      conpair_pileups: pair_process/conpair_pileups
      mafs: pair_process/maf_file
      files:
        valueFrom: ${ return []; }
      directories:
        valueFrom: ${ return []; }
    out: [consolidated_results,qc_pdf]
