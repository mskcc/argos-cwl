#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: gather-metrics-sample
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:

  bam: File
  genome: string
  bait_intervals: File
  target_intervals: File
  fp_intervals: File
  tmp_dir: string
  gatk_jar_path: string
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
outputs:

  gcbias_pdf:
    type: File
    outputSource: gcbias_metrics/pdf
  gcbias_metrics:
    type: File
    outputSource: gcbias_metrics/out_file
  gcbias_summary:
    type: File
    outputSource: gcbias_metrics/summary
  as_metrics:
    type: File
    outputSource: as_metrics/out_file
  hs_metrics:
    type: File
    outputSource: hs_metrics/out_file
  per_target_coverage:
    type: File
    outputSource: hst_metrics/per_target_out
  insert_metrics:
    type: File
    outputSource: insert_metrics/is_file
  insert_pdf:
    type: File
    outputSource: insert_metrics/is_hist
  doc_basecounts:
    type: File
    outputSource: doc/out_file
  conpair_pileup:
    type: File
    outputSource: pileup/out_file

steps:

  as_metrics:
    run: ../../tools/picard.CollectAlignmentSummaryMetrics/2.9/picard.CollectAlignmentSummaryMetrics.cwl
    in:
      I: bam
      REFERENCE_SEQUENCE: ref_fasta
      O:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".asmetrics")}
      LEVEL:
        valueFrom: ${return ["null", "SAMPLE"]}
      TMP_DIR: tmp_dir
      java_temp: tmp_dir
    out: [out_file]

  hs_metrics:
    run: ../../tools/picard.CollectHsMetrics/2.9/picard.CollectHsMetrics.cwl
    in:
      BI: bait_intervals
      TI: target_intervals
      I: bam
      REFERENCE_SEQUENCE: ref_fasta
      O:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".hsmetrics")}
      LEVEL:
        valueFrom: ${ return ["null", "SAMPLE"];}
      TMP_DIR: tmp_dir
      java_temp: tmp_dir
    out: [out_file, per_target_out]

  hst_metrics:
    run: ../../tools/picard.CollectHsMetrics/2.9/picard.CollectHsMetrics.cwl
    in:
      BI: bait_intervals
      TI: target_intervals
      I: bam
      REFERENCE_SEQUENCE: ref_fasta
      O:
        valueFrom: ${ return "all_reads_hsmerics_dump.txt"; }
      PER_TARGET_COVERAGE:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".hstmetrics")}
      LEVEL:
        valueFrom: ${ return ["ALL_READS"];}
      TMP_DIR: tmp_dir
      java_temp: tmp_dir
    out: [per_target_out]

  insert_metrics:
    run: ../../tools/picard.CollectInsertSizeMetrics/2.9/picard.CollectInsertSizeMetrics.cwl
    in:
      I: bam
      H:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".ismetrics.pdf")}
      O:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".ismetrics")}
      LEVEL:
        valueFrom: ${ return ["null", "SAMPLE"];}
      TMP_DIR: tmp_dir
      java_temp: tmp_dir
    out: [ is_file, is_hist]
  gcbias_metrics:
    run: ../../tools/picard.CollectGcBiasMetrics/2.9/picard.CollectGcBiasMetrics.cwl
    in:
      I: bam
      REFERENCE_SEQUENCE: ref_fasta
      O:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".gcbiasmetrics") }
      CHART:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".gcbias.pdf")}
      S:
        valueFrom: ${ return inputs.I.basename.replace(".bam", ".gcbias.summary")}
      TMP_DIR: tmp_dir
      java_temp: tmp_dir
    out: [pdf, out_file, summary]
  doc:
    run: ../../tools/gatk.DepthOfCoverage/3.3-0/gatk.DepthOfCoverage.cwl
    in:
      input_file: bam
      intervals: fp_intervals
      reference_sequence: ref_fasta
      out:
        valueFrom: ${ return inputs.input_file.basename.replace(".bam", "_FP_base_counts.txt") }
      omitLocustable:
        valueFrom: ${ return true; }
      omitPerSampleStats:
        valueFrom: ${ return true; }
      read_filter:
        valueFrom: ${ return ["BadCigar"];}
      minMappingQuality:
        valueFrom: ${ return "10"; }
      minBaseQuality:
        valueFrom: ${ return "3"; }
      omitIntervals:
        valueFrom: ${ return true; }
      printBaseCounts:
        valueFrom: ${ return true; }
      java_temp: tmp_dir
    out: [out_file]
  pileup:
    run: ../../tools/conpair/0.3.3/conpair-pileup.cwl
    in:
      bam: bam
      ref: ref_fasta
      gatk: gatk_jar_path
      java_temp: tmp_dir
      markers_bed: conpair_markers_bed
      java_xmx:
         valueFrom: ${ return ["24g"]; }
      outfile:
         valueFrom: ${ return inputs.bam.basename.replace(".bam", ".pileup"); }
    out: [out_file]