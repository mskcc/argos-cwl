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
      inputs:
        files:
          type: File[] 
      outputs: 
        concat_file:
          type: stdout