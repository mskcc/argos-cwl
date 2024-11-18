#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand:
  - /usr/local/bin/delly
  - call

id: delly-call

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.x)
      - $(inputs.normal_bam)
      - $(inputs.tumor_bam)
  ResourceRequirement:
    ramMin: 8000
    coresMin: 3
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/delly:0.7.7

doc: |
  None

inputs:
  t:
    type: ['null', string]
    default: DEL
    doc: SV type (DEL, DUP, INV, BND, INS)
    inputBinding:
      prefix: --type

  g:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
    doc: genome fasta file
    inputBinding:
      prefix: --genome

  x:
    type: ['null', File]
    doc: file with regions to exclude
    inputBinding:
      prefix: --exclude

  o:
    type: ['null', string]
    default: sv.bcf
    doc: SV BCF output file
    inputBinding:
      prefix: --outfile

  q:
    type: ['null', int]
    default: 1
    doc: min. paired-end mapping quality
    inputBinding:
      prefix: --map-qual

  s:
    type: ['null', int]
    default: 9
    doc: insert size cutoff, median+s*MAD (deletions only)
    inputBinding:
      prefix: --mad-cutoff

  n:
    type: ['null', boolean]
    default: false
    doc: no small InDel calling
    inputBinding:
      prefix: --noindels

  v:
    type: ['null', string]
    doc: input VCF/BCF file for re-genotyping
    inputBinding:
      prefix: --vcffile

  u:
    type: ['null', int]
    default: 5
    doc: min. mapping quality for genotyping
    inputBinding:
      prefix: --geno-qual

  normal_bam:
    type: File
    doc: Sorted normal bam
    inputBinding:
      position: 1
    secondaryFiles: [.bai]
  tumor_bam:
    type: File
    doc: Sorted tumor bam
    inputBinding:
      position: 1
    secondaryFiles: [.bai]
  all_regions:
    type: ['null', boolean]
    default: false
    doc: include regions marked in this genome
    inputBinding:
      prefix: --all_regions

  stderr:
    type: ['null', string]
    doc: log stderr to file
    inputBinding:
      prefix: --stderr

  stdout:
    type: ['null', string]
    doc: log stdout to file
    inputBinding:
      prefix: --stdout


outputs:
  sv_file:
    type: File
    secondaryFiles:
      - ^.bcf.csi
    outputBinding:
      glob: |
        ${
          if (inputs.o)
            return inputs.o;
          return null;
        }
