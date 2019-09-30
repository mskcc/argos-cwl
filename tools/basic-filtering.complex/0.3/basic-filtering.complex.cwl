#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand:
  - python
  - /usr/bin/basicfiltering/filter_complex.py
id: basic-filtering-complex
requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 16000
    coresMin: 2
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-basic-filtering:0.3

doc: |
  Given a VCF listing somatic events and a TN-pair of BAMS, apply a complex filter based on indels/soft-clipping noise

inputs:
  inputVcf:
    type:
    - string
    - File
    doc: Input VCF file
    inputBinding:
      prefix: --input-vcf

  normal_bam:
    type: File
    doc: Normal Bam file
    inputBinding:
      prefix: --normal-bam

  tumor_bam:
    type: File
    doc: Tumor Bam file
    inputBinding:
      prefix: --tumor-bam

  tumor_id:
    type: ["null", string]
    doc: Tumor sample ID
    inputBinding:
      prefix: --tumor-id

  output_vcf:
    type: ["null", string]
    doc: Output VCF file
    inputBinding:
      prefix: --output-vcf

  flank_len:
    type: ["null", int]
    doc: Flanking bps around event to check for noise
    default: 50
    inputBinding:
      prefix: --flank-len

  mapping_qual:
    type: ["null", int]
    doc: Minimum mapping quality of noisy reads
    default: 20
    inputBinding:
      prefix: --mapping-qual

  nrm_noise:
    type: ["null", float]
    doc: Maximum allowed normal noise
    default: 0.1
    inputBinding:
      prefix: --nrm-noise

  tum_noise:
    type: ["null", float]
    doc: Maximum allowed tumor noise
    default: 0.2
    inputBinding:
      prefix: --tum-noise


outputs:
  vcf:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_vcf)
            return inputs.output_vcf;
          return null;
        }