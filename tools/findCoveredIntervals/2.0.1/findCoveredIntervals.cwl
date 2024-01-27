#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand: findCoveredIntervals_2.0.1.sh

doc: |
  None

requirements:
    InlineJavascriptRequirement: {}

#
# Call signature from realignment.cwl
#
# find_covered_intervals:
#     run: ../../tools/findCoveredIntervals/1.0.1/findCoveredIntervals.cwl
#     in:
#         reference_sequence: ref_fasta
#         coverage_threshold:
#             valueFrom: ${ return ["3"];}
#         minBaseQuality:
#             valueFrom: ${ return ["20"];}
#         intervals: intervals
#         input_file: bams
#         tumor_name: tumor_name
#         normal_name: normal_name
#         out:
#             valueFrom: ${ return inputs.tumor_name + "." + inputs.normal_name + ".fci.list"; }
#     out: [fci_list]

inputs:

  reference_sequence:
    type: File
    inputBinding:
      prefix: --reference_sequence
      position: 2

  input_file:
    type:
      type: array
      items: File
      inputBinding:
        prefix: --input_file
    inputBinding:
      position: 2
    doc: Input file containing sequence data (SAM or BAM)

  intervals:
    type:
      type: array
      items: string
      inputBinding:
        prefix: --intervals
        separate: true
    inputBinding:
      position: 2
    doc: One or more genomic intervals over which to operate

  out:
    type: string
    doc: An output file created by the walker. Will overwrite contents if file exists
    inputBinding:
      prefix: --out
      position: 2

  coverage_threshold:
    type:
    - 'null'
    - type: array
      items: string
    doc: The minimum allowable coverage to be considered covered
    inputBinding:
      prefix: --coverage_threshold
      position: 2

  minBaseQuality:
    type:
    - 'null'
    - type: array
      items: string

    doc: The minimum allowable base quality score to be counted for coverage
    inputBinding:
      prefix: --minBaseQuality
      position: 2

  num_threads:
    type:
    - 'null'
    - string
    doc: Number of data threads to allocate to this analysis
    inputBinding:
      prefix: --num_threads
      position: 2

  interval_type:
    type:
    - 'null'
    - string
    doc: Type of intervals to return STATIC of DYNAMIC
    inputBinding:
      prefix: --interval_type
      position: 2

outputs:

  fci_list:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.out)
            return inputs.out;
          return null;
        }
