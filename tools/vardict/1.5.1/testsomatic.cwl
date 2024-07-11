#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- Rscript
- /usr/bin/vardict/testsomatic.R
id: testsomatic

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 4
    ramMin: 12000
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-vardict:1.5.1


inputs:
  input_vardict:
    type: File
outputs:
  output_var:
    type: File?
    outputBinding:
      glob: output_testsomatic.var

stdin: $(inputs.input_vardict.path)
stdout: output_testsomatic.var
