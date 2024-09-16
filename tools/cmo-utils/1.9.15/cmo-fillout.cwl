#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: [ "sh", "run.sh" ]
id: cmo-fillout

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 48000
    coresMin: 6
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-cmo-utils:1.9.15
  # Fix for error;
  # FATAL:   exec /usr/bin/cmo_fillout failed: fork/exec /usr/bin/cmo_fillout: argument list too long
  # shorten the arg list run by singularity exec by embedding it in a shell script
  # from this:
  # cmo_fillout --n_threads 4 --bams 1.bam 2.bam ... --maf hotspot-list-union-v1-v2.maf --format 1 --ref-fasta b37.fasta
  # to this:
  # sh run.sh --maf hotspot-list-union-v1-v2.maf --format 1 --ref-fasta b37.fasta
  InitialWorkDirRequirement:
    listing:
      - entryname: run.sh
        entry: |-
          set -eu
          bams='${ return inputs.bams.map((a) => a.path).join(' '); }'
          cmo_fillout --bams \${bams} $@

doc: |
  Fillout allele counts for a MAF file using GetBaseCountsMultiSample on BAMs

inputs:
  maf:
    type: File
    doc: MAF file on which to fillout
    inputBinding:
      prefix: --maf

  pairing:
    type: ['null', File]
    doc: Tab separated pairing file, normal tumor
    inputBinding:
      prefix: --pairing-file

  bams:
    type:
      type: array
      items: [string, File]
    doc: BAM files to fillout with

  ref_fasta:
    type: File
    doc: Reference assembly file of BAM files, e.g. hg19/grch37/b37
    inputBinding:
      prefix: --ref-fasta
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict

  output:
    type: ['null', string]
    doc: Filename for output of raw fillout data in MAF/VCF format
    inputBinding:
      prefix: --output

  portal_output:
    type: ['null', string]
    doc: Filename for a portal-friendly output MAF
    inputBinding:
      prefix: --portal-output

  fillout:
    type: ['null', string]
    doc: Precomputed fillout file from GBCMS (using this skips GBCMS)
    inputBinding:
      prefix: --fillout

  output_format:
    type: string
    doc: Output format MAF(1) or tab-delimited with VCF based coordinates(2)
    inputBinding:
      prefix: --format

arguments:
  - position: 0
    prefix: '--n_threads'
    valueFrom: $(runtime.cores)

outputs:

  fillout_out:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output)
            return inputs.output;
          else
            return inputs.maf.basename.replace(".maf", ".fillout");
        }

  portal_fillout:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.portal_output)
            return inputs.portal_output;
          else
            return inputs.maf.basename.replace(".maf", ".fillout.portal.maf");
        }
