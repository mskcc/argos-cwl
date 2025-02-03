#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: Unpack-sample-bam
requirements:
  MultipleInputFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:

  sample_id: string
  bam: File


outputs:

  r1:
    type: File[]
    outputSource: consolidate_reads/r1
  r2:
    type: File[]
    outputSource: consolidate_reads/r2

steps:
  unpack_bam:
    run: ../../tools/unpack-bam/0.1.0/unpack-bam.cwl
    in:
      input_bam: bam
      sample_id: sample_id
    out: [rg_output]
    scatter: [input_bam]
    scatterMethod: dotproduct
  flatten_dir:
    run: ../../tools/flatten-array/1.0.0/flatten-array-directory.cwl
    in:
      directory_list: unpack_bam/rg_output
    out: [output_directory]
  consolidate_reads:
    run: ../../tools/consolidate-files/consolidate-reads.cwl
    in:
      reads_dir: flatten_dir/output_directory
    out: [r1,r2]