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
        grouping_file: File
        request_file: File
        pairing_file: File
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
        opt_dup_pix_dist: string
        facets_pcval: int
        facets_cval: int
        abra_ram_min: int
        scripts_bin: string
        gatk_jar_path: string
  pairs:
    type:
      type: array
      items:
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
  bams:
    type:
      type: array
      items:
        type: array
        items: File
    secondaryFiles:
      - ^.bai
    outputSource: pair_process/bams
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
  # facets
  facets_png:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: pair_process/facets_png
  facets_txt_hisens:
    type:
      type: array
      items: File
    outputSource: pair_process/facets_txt_hisens
  facets_txt_purity:
    type:
      type: array
      items: File
    outputSource: pair_process/facets_txt_purity
  facets_out:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: pair_process/facets_out
  facets_rdata:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: pair_process/facets_rdata
  facets_seg:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: pair_process/facets_seg
  facets_counts:
    type:
      type: array
      items: File
    outputSource: pair_process/facets_counts
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
      pair: pairs
      ref_fasta: ref_fasta
      mouse_fasta: mouse_fasta
    out: [bams,clstats1,clstats2,md_metrics,as_metrics,hs_metrics,insert_metrics,insert_pdf,per_target_coverage,qual_metrics,qual_pdf,doc_basecounts,gcbias_pdf,gcbias_metrics,gcbias_summary,conpair_pileups,mutect_vcf,mutect_callstats,vardict_vcf,combine_vcf,annotate_vcf,vardict_norm_vcf,mutect_norm_vcf,facets_png,facets_txt_hisens,facets_txt_purity,facets_out,facets_rdata,facets_seg,facets_counts,merged_file_unfiltered,merged_file,maf_file,portal_file,maf]
    scatter: [pair]
    scatterMethod: dotproduct

  run_cdna_contam_check:
    run: tools/roslin-qc/create-cdna-contam.cwl
    in:
      runparams: runparams
      input_mafs: pair_process/maf_file
      project_prefix:
        valueFrom: ${ return inputs.runparams.project_prefix; }
    out: [ cdna_contam_output ]

  generate_qc:
    run: modules/project/generate-qc.cwl
    in:
      db_files: db_files
      runparams: runparams
      bams: pair_process/bams
      ref_fasta: ref_fasta
      clstats1: pair_process/clstats1
      clstats2: pair_process/clstats2
      md_metrics: pair_process/md_metrics
      hs_metrics: pair_process/hs_metrics
      insert_metrics: pair_process/insert_metrics
      per_target_coverage: pair_process/per_target_coverage
      qual_metrics: pair_process/qual_metrics
      doc_basecounts: pair_process/doc_basecounts
      conpair_pileups: pair_process/conpair_pileups
      cdna_contam_output: run_cdna_contam_check/cdna_contam_output
      files:
        valueFrom: ${ return [inputs.cdna_contam_output]; }
      directories:
        valueFrom: ${ return []; }
    out: [consolidated_results,qc_pdf]
