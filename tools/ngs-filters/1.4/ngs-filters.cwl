#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: ngs-filters

baseCommand:
  - python
  - /usr/bin/ngs-filters/run_ngs-filters.py

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 36000
    coresMin: 3
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-ngs-filters:1.4

doc: |
  This tool flags false-positive somatic calls in a given MAF file

inputs:
  verbose:
    type: ['null', boolean]
    default: false
    doc: make lots of noise
    inputBinding:
      prefix: --verbose

  inputMaf:
    type:
    - File
    doc: Input maf file which needs to be tagged
    inputBinding:
      prefix: --input-maf

  outputMaf:
    type: string
    doc: Output maf file name
    inputBinding:
      prefix: --output-maf

  NormalPanelMaf:
    type:
    - 'null'
    - string
    - File
    doc: Path to fillout maf file of panel of standard normals
    inputBinding:
      prefix: --normal-panel-maf

  NormalCohortMaf:
    type:
    - 'null'
    - string
    - File
    doc: Path to fillout maf file of cohort normals
    inputBinding:
      prefix: --normal-cohort-maf

  NormalCohortSamples:
    type: ['null', string]
    doc: File with list of normal samples
    inputBinding:
      prefix: --normalSamplesFile

  inputHSP:
    type:
    - 'null'
    - string
    - File
    doc: Input txt file which has hotspots
    inputBinding:
      prefix: --input-hotspot

outputs:
  output:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outputMaf)
            return inputs.outputMaf;
          return null;
        }
