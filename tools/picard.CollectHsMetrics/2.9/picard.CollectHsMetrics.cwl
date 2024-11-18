#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: picard-CollectHsMetrics

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/picard-tools/picard.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "CollectHsMetrics"
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
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/picard:2.9

doc: |
  None

inputs:

  I:
    type: File
    inputBinding:
      prefix: I=
      position: 2
      separate: false

  BI:
    type: File
    doc: An interval list file that contains the locations of the baits used. Default
      value - null. This option must be specified at least 1 times.
    inputBinding:
      prefix: BAIT_INTERVALS=
      position: 2
      separate: false

  N:
    type: ['null', string]
    doc: Bait set name. If not provided it is inferred from the filename of the bait
      intervals. Default value - null.
    inputBinding:
      prefix: BAIT_SET_NAME=
      position: 2
      separate: false

  TI:
    type: File
    doc: An interval list file that contains the locations of the targets. Default
      value - null. This option must be specified at least 1 times.
    inputBinding:
      prefix: TARGET_INTERVALS=
      position: 2
      separate: false


  O:
    type: string
    doc: The output file to write the metrics to. Required.
    inputBinding:
      prefix: O=
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

  PER_TARGET_COVERAGE:
    type: ['null', string]
    doc: An optional file to output per target coverage information to. Default value
      - null.
    inputBinding:
      prefix: PER_TARGET_COVERAGE=
      separate: false
      position: 2

  PER_BASE_COVERAGE:
    type: ['null', string]
    doc: An optional file to output per base coverage information to. The per-base
      file contains one line per target base and can grow very large. It is not recommended
      for use with large target sets. Default value - null.
    inputBinding:
      prefix: PER_BASE_COVERAGE=
      separate: false
      position: 2

  NEAR_DISTANCE:
    type: ['null', string]
    doc: The maximum distance between a read and the nearest probe/bait/amplicon for
      the read to be considered 'near probe' and included in percent selected. Default
      value - 250. This option can be set to 'null' to clear the default value.
    inputBinding:
      prefix: NEAR_DISTANCE=
      separate: false
      position: 2

  MQ:
    type: ['null', string]
    doc: Minimum mapping quality for a read to contribute coverage. Default value
      - 20. This option can be set to 'null' to clear the default value.
    inputBinding:
      prefix: MINIMUM_MAPPING_QUALITY=
      separate: false
      position: 2

  Q:
    type: ['null', string]
    doc: Minimum base quality for a base to contribute coverage. Default value - 20.
      This option can be set to 'null' to clear the default value.
    inputBinding:
      prefix: MINIMUM_BASE_QUALITY=
      separate: false
      position: 2

  CLIP_OVERLAPPING_READS:
    type: ['null', boolean]
    doc: if we are to clip overlapping reads, false otherwise. Default value - true.
      This option can be set to 'null' to clear the default value. Possible values
      - {true, false}
    inputBinding:
      prefix: CLIP_OVERLAPPING_READS=True
      position: 2

  COVMAX:
    type: ['null', string]
    doc: Parameter to set a max coverage limit for Theoretical Sensitivity calculations.
      Default is 200. Default value - 200. This option can be set to 'null' to clear
      the default value.
    inputBinding:
      prefix: COVERAGE_CAP=
      separate: false
      position: 2

  SAMPLE_SIZE:
    type: ['null', string]
    doc: Sample Size used for Theoretical Het Sensitivity sampling. Default is 10000.
      Default value - 10000. This option can be set to 'null' to clear the default
      value.
    inputBinding:
      prefix: SAMPLE_SIZE=
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

  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
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
  per_target_out:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.PER_TARGET_COVERAGE)
            return inputs.PER_TARGET_COVERAGE;
          return null;
        }
