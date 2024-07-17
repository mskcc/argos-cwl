#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand:
  - /usr/bin/snp-pileup
id: htstools-snp-pileup

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 3
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-htstools:0.1.1.bash


doc: |
  run snp-pileup

inputs:
  count_orphans:
    type: ['null', boolean]
    default: false
    doc: Do not discard anomalous read pairs.
    inputBinding:
      prefix: --count-orphans

  max_depth:
    type: ['null', string]
    doc: Sets the maximum depth. Default is 4000.
    inputBinding:
      prefix: --max-depth

  gzip:
    type: ['null', boolean]
    default: false
    doc: Compresses the output file with BGZF.
    inputBinding:
      prefix: --gzip

  progress:
    type: ['null', boolean]
    default: false
    doc: Show a progress bar. WARNING - requires additionaltime to calculate number
      of SNPs, and will takelonger than normal.
    inputBinding:
      prefix: --progress

  pseudo_snps:
    type: ['null', string]
    doc: Every MULTIPLE positions, if there is no SNP,insert a blank record with the
      total count at theposition.
    inputBinding:
      prefix: --pseudo-snps

  min_map_quality:
    type: ['null', string]
    doc: Sets the minimum threshold for mappingquality. Default is 0.
    inputBinding:
      prefix: --min-map-quality

  min_base_quality:
    type: ['null', string]
    doc: Sets the minimum threshold for base quality.Default is 0.
    inputBinding:
      prefix: --min-base-quality

  min_read_counts:
    type: ['null', string]
    default: 10,0
    doc: Comma separated list of minimum read counts fora position to be output. Default
      is 0.
    inputBinding:
      prefix: --min-read-counts

  verbose:
    type: ['null', boolean]
    default: false
    doc: Show detailed messages.
    inputBinding:
      prefix: --verbose

  ignore_overlaps:
    type: ['null', boolean]
    default: false
    doc: Disable read-pair overlap detection.
    inputBinding:
      prefix: --ignore-overlaps

  vcf:
    type: File

    doc: vcf file
    inputBinding:
      position: 1

  output_file:
    type: string

    doc: output file
    inputBinding:
      position: 2

  normal_bam:
    type: File

    doc: normal bam
    inputBinding:
      position: 3

  tumor_bam:
    type: File

    doc: tumor bam
    inputBinding:
      position: 4

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
  out_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_file)
            return inputs.output_file;
          return null;
        }
