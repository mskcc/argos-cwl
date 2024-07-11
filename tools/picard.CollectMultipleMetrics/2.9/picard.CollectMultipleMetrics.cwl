#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: picard-CollectMultipleMetrics

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/picard-tools/picard.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "CollectMultipleMetrics"
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

  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false
      position: 2

  EXT:
    type: ['null', string]
    doc: Append the given file extension to all metric file names (ex. OUTPUT.insert_size_metrics.EXT).
      None if null Default value - null.
    inputBinding:
      prefix: FILE_EXTENSION=
      position: 2
      separate: false

  PROGRAM:
    type:
    - 'null'
    - type: array
      items: string
      inputBinding:
        prefix: PROGRAM=
        separate: false
    inputBinding:
      position: 2
    doc: List of metrics programs to apply during the pass through the SAM file. Possible
      values - {CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, QualityScoreDistribution,
      MeanQualityByCycle} This option may be specified 0 or more times. This option
      can be set to 'null' to clear the default list.

  INTERVALS:
    type: ['null', string]
    doc: An optional list of intervals to restrict analysis to. Only pertains to some
      of the PROGRAMs. Programs whose stand-alone CLP does not have an INTERVALS argument
      will silently ignore this argument. Default value - null.
    inputBinding:
      prefix: INTERVALS=
      position: 2
      separate: false

  DB_SNP:
    type: ['null', string]
    doc: VCF format dbSNP file, used to exclude regions around known polymorphisms
      from analysis by some PROGRAMs; PROGRAMs whose CLP doesn't allow for this argument
      will quietly ignore it. Default value - null.
    inputBinding:
      prefix: DB_SNP=
      position: 2
      separate: false

  UNPAIRED:
    type: ['null', boolean]
    doc: Include unpaired reads in CollectSequencingArtifactMetrics. If set to true
      then all paired reads will be included as well - MINIMUM_INSERT_SIZE and MAXIMUM_INSERT_SIZE
      will be ignored in CollectSequencingArtifactMetrics. Default value - false.
      This option can be set to 'null' to clear the default value. Possible values
      - {true, false}
    inputBinding:
      prefix: INCLUDE_UNPAIRED=True
      position: 2

  O:
    type: string
    doc: Base name of output files. Required.
    inputBinding:
      prefix: OUTPUT=
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
  qual_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O.concat('.quality_by_cycle_metrics');
          return null;
        }
  qual_hist:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O.concat('.quality_by_cycle.pdf');
          return null;
        }
  is_file:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O.concat('.insert_size_metrics');
          return null;
        }
  is_hist:
    type: File?
    outputBinding:
      glob: |
        ${
          if (inputs.O)
            return inputs.O.concat('.insert_size_histogram.pdf');
          return null;
        }
