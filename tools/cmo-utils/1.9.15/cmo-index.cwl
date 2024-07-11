#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: [cmo_index]
label: cmo-index

requirements:
  ResourceRequirement:
    ramMin: 16000
    coresMin: 3
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-cmo-utils:1.9.15
  InitialWorkDirRequirement:
    listing: [ $(inputs.bam) ]

inputs:

  bam:
    type: File
    inputBinding:
        prefix: --bam

outputs:

  bam_indexed:
    type: File
    outputBinding:
      glob: $(inputs.bam.basename)
    secondaryFiles: ["^.bai", ".bai"]
