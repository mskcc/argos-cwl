#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- cat
- $(inputs.files)
- |
- sort
- -k2,2V
- -k3,3n
- > 
- vardict_concat.prevcf
id: vardict_concat

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 4
    ramMin: 24000
  DockerRequirement:
    dockerPull: broadinstitute_gatk:4.1.0.0

inputs:
  files: File[]

outputs:
  output_concat_var:
    type: File
    outputBinding:
      glob: vardict_concat.prevcf