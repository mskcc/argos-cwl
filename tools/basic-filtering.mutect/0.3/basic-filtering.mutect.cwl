#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand:
  - python
  - /usr/bin/basicfiltering/filter_mutect.py
id: basic-filtering-mutect
requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 16000
    coresMin: 4
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-basic-filtering:0.3


doc: |
  Filter snps from the output of muTect v1.14

inputs:
  verbose:
    type: ['null', boolean]
    default: false
    doc: More verbose logging to help with debugging
    inputBinding:
      prefix: --verbose

  inputVcf:
    type:
    - string
    - File
    doc: Input vcf muTect file which needs to be filtered
    inputBinding:
      prefix: --inputVcf

  inputTxt:
    type:
    - string
    - File
    doc: Input txt muTect file which needs to be filtered
    inputBinding:
      prefix: --inputTxt

  tsampleName:
    type: string
    doc: Name of the tumor Sample
    inputBinding:
      prefix: --tsampleName

  refFasta:
    type:
    - string
    - File
    doc: Reference genome in fasta format
    inputBinding:
      prefix: --refFasta

  dp:
    type: ['null', int]
    default: 5
    doc: Tumor total depth threshold
    inputBinding:
      prefix: --totaldepth

  ad:
    type: ['null', int]
    default: 3
    doc: Tumor allele depth threshold
    inputBinding:
      prefix: --alleledepth

  tnr:
    type: ['null', int]
    default: 5
    doc: Tumor-Normal variant frequency ratio threshold
    inputBinding:
      prefix: --tnRatio

  vf:
    type: ['null', float]
    default: 0.01
    doc: Tumor variant frequency threshold
    inputBinding:
      prefix: --variantfraction

  hotspotVcf:
    type:
    - 'null'
    - string
    - File
    doc: Input vcf file with hotspots that skip VAF ratio filter
    inputBinding:
      prefix: --hotspotVcf

  outdir:
    type: ['null', string]
    doc: Full Path to the output dir.
    inputBinding:
      prefix: --outDir


outputs:
  vcf:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.inputVcf)
            return inputs.inputVcf.basename.replace(".vcf","_STDfilter.norm.vcf.gz");
          return null;
        }
    secondaryFiles: ["^.tbi", ".tbi"]