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
  consolidate_reads:
    run: ../../tools/consolidate-files/consolidate-reads.cwl
    in:
      reads_dir: unpack_bam/rg_output
    out: [r1,r2]