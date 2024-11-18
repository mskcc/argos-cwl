class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - samtools
  - merge
inputs:
  - id: input_bams
    type: 'File[]'
    inputBinding:
      position: 2
    doc: Input array containing files to be merged
outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: '*merged.bam'
arguments:
  - position: 0
    valueFrom: '$(inputs.input_bams[0].basename.replace(''bam'', ''merged.bam''))'
  - position: 0
    prefix: '-test'
requirements:
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 6
  - class: DockerRequirement
    dockerPull: '058264265624.dkr.ecr.us-east-1.amazonaws.com/htslib:1.9'
  - class: InlineJavascriptRequirement
'dct:contributor':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
'dct:creator':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
