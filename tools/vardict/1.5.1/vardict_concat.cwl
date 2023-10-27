#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
id: vardict_concat

requirements:
    MultipleInputFeatureRequirement: {}
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
    InlineJavascriptRequirement: {}
    StepInputExpressionRequirement: {}

inputs:
  files: File[]
outputs:
  concat_file:
    type: File
    outputSource: cat_files/concat_file

steps:

  cat_files:
    in:
      files: files
    out: [ concat_file ]
    run:
      class: CommandLineTool
      baseCommand: [ 'cat' ]
      stdout: output.txt
      inputs:
        files:
          type: File[]
          inputBinding:
            position: 1
      outputs:
        concat_file:
          type: stdout

    sort_file:
      in:
        cat_file: cat_files/concat_file
      out: [ sorted_file ]
      run:
        class: CommandLineTool
        baseCommand: [ 'sort', '-k2,2V', '-k3,3n' ]
        stdout: sorted_prevcf_file.txt
        inputs:
          cat_file:
            type: File
            inputBinding:
              position: 1
        outputs:
          sorted_file:
            type: stdout