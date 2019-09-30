#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: remove-variants

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-remove-variants:0.1.1

doc: |
  Remove snps/indels from the output maf where a complex variant is called

inputs:

  verbose:
    type: ['null', boolean]
    default: false
    doc: make lots of noise
    inputBinding:
      prefix: --verbose

  inputMaf:
    type:

    - string
    - File
    doc: Input maf file which needs to be fixed
    inputBinding:
      prefix: --input-maf

  outputMaf:
    type: string

    doc: Output maf file name
    inputBinding:
      prefix: --output-maf

  outdir:
    type: ['null', string]
    doc: Full Path to the output dir.
    inputBinding:
      prefix: --outDir


outputs:
  maf:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outputMaf )
            return inputs.outputMaf;
          return null;
        }
