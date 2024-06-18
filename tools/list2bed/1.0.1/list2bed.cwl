#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: list2bed
baseCommand:
  - python
  - /usr/bin/list2bed.py

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 2000
    coresMin: 3
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-list2bed:1.0.1

doc: |
  Convert a Picard interval list file to a UCSC BED format

inputs:
  input_file:
    type:

    - string
    - File
    - type: array
      items: string
    doc: picard interval list
    inputBinding:
      prefix: --input_file

  no_sort:
    type: ['null', boolean]
    default: true
    doc: sort bed file output
    inputBinding:
      prefix: --no_sort


  output_filename:
    type: string
    doc: output bed file
    inputBinding:
      prefix: --output_file
outputs:
  output_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_filename)
            return inputs.output_filename;
          return null;
        }
