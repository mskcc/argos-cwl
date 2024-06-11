#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: picard-CollectInsertSizeMetrics

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/picard-tools/picard.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "CollectInsertSizeMetrics"
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
    dockerPull: mskcc/roslin-variant-picard:2.9


doc: |
  None

inputs:

  I:
    type: File
    inputBinding:
      prefix: I=
      position: 2
      separate: false

  H:
    type: string
    doc: File to write insert size Histogram chart to. Required.
    inputBinding:
      prefix: HISTOGRAM_FILE=
      position: 2
      separate: false

  DEVIATIONS:
    type: ['null', string]
    doc: Generate mean, sd and plots by trimming the data down to MEDIAN + DEVIATIONS*MEDIAN_ABSOLUTE_DEVIATION.
      This is done because insert size data typically includes enough anomalous values
      from chimeras and other artifacts to make the mean and sd grossly misleading
      regarding the real distribution. Default value - 10.0. This option can be set
      to 'null' to clear the default value.
    inputBinding:
      prefix: DEVIATIONS=
      position: 2
      separate: false

  W:
    type: ['null', string]
    doc: Explicitly sets the Histogram width, overriding automatic truncation of Histogram
      tail. Also, when calculating mean and standard deviation, only bins <= Histogram_WIDTH
      will be included. Default value - null.
    inputBinding:
      prefix: HISTOGRAM_WIDTH=
      position: 2
      separate: false

  M:
    type: ['null', string]
    doc: When generating the Histogram, discard any data categories (out of FR, TANDEM,
      RF) that have fewer than this percentage of overall reads. (Range - 0 to 1).
      Default value - 0.05. This option can be set to 'null' to clear the default
      value.
    inputBinding:
      prefix: MINIMUM_PCT=
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

  INCLUDE_DUPLICATES:
    type: ['null', boolean]
    doc: If true, also include reads marked as duplicates in the insert size histogram.
      Default value - false. This option can be set to 'null' to clear the default
      value. Possible values - {true, false}
    inputBinding:
      prefix: INCLUDE_DUPLICATES=True
      position: 2

  O:
    type: string
    doc: File to write the output to. Required.
    inputBinding:
      prefix: O=
      separate: false
      position: 2

  AS:
    type: ['null', boolean]
    doc: If true (default), then the sort order in the header file will be ignored.
      Default value - true. This option can be set to 'null' to clear the default
      value. Possible values - {true, false}
    inputBinding:
      prefix: ASSUME_SORTED=True
      separate: false
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
  is_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O;
          return null;
        }
  is_hist:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.H)
            return inputs.H;
          return null;
        }
