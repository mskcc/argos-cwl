#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: picard-CollectGcBiasMetrics

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/picard-tools/picard.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "CollectGcBiasMetrics"
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
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-picard:2.9.bash


doc: |
  None

inputs:

  I:
    type: File
    inputBinding:
      prefix: I=
      position: 2
      separate: false

  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false
      position: 2

  CHART:
    type: string
    doc: The PDF file to render the chart to. Required.
    inputBinding:
      prefix: CHART_OUTPUT=
      position: 2
      separate: false

  S:
    type: string
    doc: The text file to write summary metrics to. Required.
    inputBinding:
      prefix: SUMMARY_OUTPUT=
      position: 2
      separate: false

  WINDOW_SIZE:
    type: ['null', string]
    doc: The size of the scanning windows on the reference genome that are used to
      bin reads. Default value - 100. This option can be set to 'null' to clear the
      default value.
    inputBinding:
      prefix: SCAN_WINDOW_SIZE=
      position: 2
      separate: false

  MGF:
    type: ['null', string]
    doc: For summary metrics, exclude GC windows that include less than this fraction
      of the genome. Default value - 1.0E-5. This option can be set to 'null' to clear
      the default value.
    inputBinding:
      prefix: MINIMUM_GENOME_FRACTION=
      position: 2
      separate: false

  BS:
    type: ['null', boolean]
    doc: Whether the SAM or BAM file consists of bisulfite sequenced reads. Default
      value - false. This option can be set to 'null' to clear the default value.
      Possible values - {true, false}
    inputBinding:
      prefix: IS_BISULFITE_SEQUENCED=True
      position: 2

  ALSO_IGNORE_DUPLICATES:
    type: ['null', boolean]
    doc: to get additional results without duplicates. This option allows to gain
      two plots per level at the same time - one is the usual one and the other excludes
      duplicates. Default value - false. This option can be set to 'null' to clear
      the default value. Possible values - {true, false}
    inputBinding:
      prefix: ALSO_IGNORE_DUPLICATES=True
      position: 2

  O:
    type: string
    doc: File to write the output to. Required.
    inputBinding:
      prefix: O=
      position: 2
      separate: false

  AS:
    type: ['null', boolean]
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
      position: 2
      separate: false

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
      position: 2
      separate: false

  VALIDATION_STRINGENCY:
    type: ['null', string]
    default: SILENT
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      position: 2
      separate: false

  COMPRESSION_LEVEL:
    type: ['null', string]
    inputBinding:
      prefix: COMPRESSION_LEVEL=
      position: 2
      separate: false

  MAX_RECORDS_IN_RAM:
    type: ['null', string]
    inputBinding:
      prefix: MAX_RECORDS_IN_RAM=
      position: 2
      separate: false

outputs:
  pdf:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.CHART)
            return inputs.CHART;
          return null;
        }
  out_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O;
          return null;
        }
  summary:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.S)
            return inputs.S;
          return null;
        }
