#/usr/bin/env cwl-runner
cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 3
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-qc:0.6.4

class: CommandLineTool
baseCommand:
  - python
  - /usr/bin/merge_insert_size_histograms.py

id: merge-insert-size-histograms
stdout: $(inputs.outfile_name)
inputs:
  files:
    type:
      type: array
      items:
        type: array
        items: File
    inputBinding:
      prefix: --files
  outfile_name:
    type: string
    inputBinding:
      prefix: --output
outputs:
  output:
    type: File
    outputBinding:
      glob: |-
        ${
          if (inputs.outfile_name)
            return inputs.outfile_name;
          return null;
         }
