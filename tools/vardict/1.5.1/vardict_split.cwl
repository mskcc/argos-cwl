#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- split
id: vardict_split

arguments:
- position: 0
  valueFrom: ${ return inputs.bedfile }
- position: 1
  prefix: -d
- position: 2
  prefix: -n
  valueFrom: ${ return "10" }
- position: 3
  valueFrom: ${ return "--additional-suffix=.bed" }

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 2
    ramMin: 1000
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-vardict:1.5.1

inputs:
  bedfile: File
outputs:
  output:
    type: 
      type: array
      items: File
    outputBinding:
      glob: x*.bed
