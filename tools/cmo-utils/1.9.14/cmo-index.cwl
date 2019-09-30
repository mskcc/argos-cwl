#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: [cmo_index]
label: cmo-index

requirements:
  ResourceRequirement:
    ramMin: 16000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-cmo-utils:1.9.14

inputs:

  bam:
    type: File
    inputBinding:
        prefix: --bam

outputs:

  bam_indexed:
    type: File
    outputBinding:
      glob: $(inputs.tumor.basename)
    secondaryFiles: ["^.bai", ".bai"]
