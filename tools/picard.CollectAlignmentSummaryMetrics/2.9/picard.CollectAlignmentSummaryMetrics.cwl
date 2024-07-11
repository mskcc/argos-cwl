#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: picard-CollectAlignmentSummaryMetrics

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/picard-tools/picard.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "CollectAlignmentSummaryMetrics"
  position: 1
  shellQuote: false
- valueFrom: "-Xms$(Math.round(parseInt(runtime.ram)/1910))G"
  position: 0
  shellQuote: false
- valueFrom: "-Xmx$(Math.floor(parseInt(runtime.ram)/1048) - 1)G"
  position: 0
  shellQuote: false
- valueFrom: "-XX:-UseGCOverheadLimit"
  position: 0
  shellQuote: false
- valueFrom: "-Djava.io.tmpdir=$(runtime.tmpdir)"
  position: 0
  shellQuote: false
- valueFrom: "TMP_DIR=$(runtime.tmpdir)"
  position: 2
  shellQuote: false

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 16000
    coresMin: 5
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-picard:2.9

doc: |
  None

inputs:

  I:
    type: File
    inputBinding:
      prefix: I=
      position: 2
      separate: false

  MAX_INSERT_SIZE:
    type: ['null', string]
    doc: Paired-end reads above this insert size will be considered chimeric along
      with inter-chromosomal pairs. Default value - 100000. This option can be set
      to 'null' to clear the default value.
    inputBinding:
      prefix: MAX_INSERT_SIZE=
      position: 2
      separate: false

  EXPECTED_PAIR_ORIENTATIONS:
    type: ['null', string]
    doc: Paired-end reads that do not have this expected orientation will be considered
      chimeric. Default value - [FR]. This option can be set to 'null' to clear the
      default value. Possible values - {FR, RF, TANDEM} This option may be specified
      0 or more times. This option can be set to 'null' to clear the default list.
    inputBinding:
      prefix: EXPECTED_PAIR_ORIENTATIONS=
      position: 2
      separate: false

  ADAPTER_SEQUENCE:
    type: ['null', string]
    doc: List of adapter sequences to use when processing the alignment metrics. Default
      value - [AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT, AGATCGGAAGAGCTCGTATGCCGTCTTCTGCTTG,
      AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT, AGATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATCTCGTATGCCGTCTTCTGCTTG,
      AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT, AGATCGGAAGAGCACACGTCTGAACTCCAGTCACNNNNNNNNATCTCGTATGCCGTCTTCTGCTTG].
      This option can be set to 'null' to clear the default value. This option may
      be specified 0 or more times. This option can be set to 'null' to clear the
      default list.
    inputBinding:
      prefix: ADAPTER_SEQUENCE=
      position: 2
      separate: false

  LEVEL:
    type:
    - 'null'
    - type: array
      items: string
      inputBinding:
        prefix: LEVEL=
        separate: false
    inputBinding:
      position: 2
  BS:
    type: ['null', string]
    doc: Whether the SAM or BAM file consists of bisulfite sequenced reads. Default
      value - false. This option can be set to 'null' to clear the default value.
      Possible values - {true, false}
    inputBinding:
      prefix: IS_BISULFITE_SEQUENCED=
      separate: false
      position: 2

  O:
    type: string
    doc: File to write the output to. Required.
    inputBinding:
      prefix: O=
      separate: false
      position: 2

  AS:
    type: ['null',boolean]
    doc: If true (default), then the sort order in the header file will be ignored.
      Default value - true. This option can be set to 'null' to clear the default
      value. Possible values - {true, false}
    inputBinding:
      prefix: ASSUME_SORTED=True
      position: 2

  STOP_AFTER:
    type: ['null', string]
    doc: Stop after processing N reads, mainly for debugging. Default value - 0. This
      option can be set to 'null' to clear the default value.
    inputBinding:
      prefix: STOP_AFTER=
      separate: false
      position: 2

  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false
      position: 2

  QUIET:
    type: ['null', boolean]
    default: false
    inputBinding:
      prefix: QUIET=True
      position: 2

  CREATE_MD5_FILE:
    type: ['null', boolean]
    default: false
    inputBinding:
      prefix: CREATE_MD5_FILE=True
      position: 2

  CREATE_INDEX:
    type: ['null', boolean]
    default: false
    inputBinding:
      prefix: CREATE_INDEX=True
      position: 2

  VERBOSITY:
    type: ['null', string]
    inputBinding:
      prefix: VERBOSITY=
      separate: false
      position: 2

  VALIDATION_STRINGENCY:
    type: ['null', string]
    default: SILENT
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false
      position: 2

  COMPRESSION_LEVEL:
    type: ['null', string]
    inputBinding:
      prefix: COMPRESSION_LEVEL=
      separate: false
      position: 2

  MAX_RECORDS_IN_RAM:
    type: ['null', string]
    inputBinding:
      prefix: MAX_RECORDS_IN_RAM=
      separate: false
      position: 2

outputs:
  out_file:
    type: File
    outputBinding:
      glob: |
        ${
            if (inputs.O)
                return inputs.O;
            return null;
        }
