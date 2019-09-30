#/usr/bin/env cwl-runner
cwlVersion: v1.0

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-roslin-qc:0.6.1

class: CommandLineTool
baseCommand: [merge_picard_metrics]
id: merge-picard-metrics-markduplicates
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
