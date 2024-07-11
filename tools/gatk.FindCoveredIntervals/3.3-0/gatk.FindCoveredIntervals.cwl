#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: gatk-FindCoveredIntervals

baseCommand:
  - java
arguments:
- valueFrom: "/usr/bin/gatk.jar"
  prefix: "-jar"
  position: 1
  shellQuote: false
- valueFrom: "FindCoveredIntervals"
  prefix: "-T"
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

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 24000
    coresMin: 4
  DockerRequirement:
    dockerPull: 058264265624.dkr.ecr.us-east-1.amazonaws.com/roslin-variant-gatk:3.3-0

doc: |
  None

inputs:

  arg_file:
    type:
    - 'null'
    - type: array
      items: string
    doc: Reads arguments from the specified file
    inputBinding:
      prefix: --arg_file
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

  read_buffer_size:
    type:
    - 'null'
    - type: array
      items: string

    doc: Number of reads per SAM file to buffer in memory
    inputBinding:
      prefix: --read_buffer_size
      position: 2

  phone_home:
    type:
    - 'null'
    - type: array
      items: string

    doc: Run reporting mode (NO_ET|AWS| STDOUT)
    inputBinding:
      prefix: --phone_home
      position: 2

  gatk_key:
    type:
    - 'null'
    - type: array
      items: string

    doc: GATK key file required to run with -et NO_ET
    inputBinding:
      prefix: --gatk_key
      position: 2

  tag:
    type:
    - 'null'
    - type: array
      items: string

    doc: Tag to identify this GATK run as part of a group of runs
    inputBinding:
      prefix: --tag
      position: 2

  read_filter:
    type:
    - 'null'
    - type: array
      items: string

    doc: Filters to apply to reads before analysis
    inputBinding:
      prefix: --read_filter
      position: 2

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

  excludeIntervals:
    type:
    - 'null'
    - type: array
      items: string

    doc: One or more genomic intervals to exclude from processing
    inputBinding:
      prefix: --excludeIntervals
      position: 2

  interval_set_rule:
    type:
    - 'null'
    - type: array
      items: string

    doc: Set merging approach to use for combining interval inputs (UNION|INTERSECTION)
    inputBinding:
      prefix: --interval_set_rule
      position: 2

  interval_merging:
    type:
    - 'null'
    - type: array
      items: string

    doc: Interval merging rule for abutting intervals (ALL| OVERLAPPING_ONLY)
    inputBinding:
      prefix: --interval_merging
      position: 2

  interval_padding:
    type:
    - 'null'
    - type: array
      items: string

    doc: Amount of padding (in bp) to add to each interval
    inputBinding:
      prefix: --interval_padding
      position: 2

  reference_sequence:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
    inputBinding:
      prefix: --reference_sequence
      position: 2

  nonDeterministicRandomSeed:
    type: ['null', boolean]
    default: false
    doc: Use a non-deterministic random seed
    inputBinding:
      prefix: --nonDeterministicRandomSeed
      position: 2

  maxRuntime:
    type:
    - 'null'
    - type: array
      items: string

    doc: Stop execution cleanly as soon as maxRuntime has been reached
    inputBinding:
      prefix: --maxRuntime
      position: 2

  maxRuntimeUnits:
    type:
    - 'null'
    - type: array
      items: string

    doc: Unit of time used by maxRuntime (NANOSECONDS|MICROSECONDS| MILLISECONDS|SECONDS|MINUTES|
      HOURS|DAYS)
    inputBinding:
      prefix: --maxRuntimeUnits
      position: 2

  downsampling_type:
    type:
    - 'null'
    - type: array
      items: string

    doc: Type of read downsampling to employ at a given locus (NONE| ALL_READS|BY_SAMPLE)
    inputBinding:
      prefix: --downsampling_type
      position: 2

  downsample_to_fraction:
    type:
    - 'null'
    - type: array
      items: string

    doc: Fraction of reads to downsample to
    inputBinding:
      prefix: --downsample_to_fraction
      position: 2

  downsample_to_coverage:
    type:
    - 'null'
    - type: array
      items: string

    doc: Target coverage threshold for downsampling to coverage
    inputBinding:
      prefix: --downsample_to_coverage
      position: 2

  baq:
    type:
    - 'null'
    - type: array
      items: string

    doc: Type of BAQ calculation to apply in the engine (OFF| CALCULATE_AS_NECESSARY|
      RECALCULATE)
    inputBinding:
      prefix: --baq
      position: 2

  baqGapOpenPenalty:
    type:
    - 'null'
    - type: array
      items: string

    doc: BAQ gap open penalty
    inputBinding:
      prefix: --baqGapOpenPenalty
      position: 2

  refactor_NDN_cigar_string:
    type: ['null', boolean]
    default: false
    doc: refactor cigar string with NDN elements to one element
    inputBinding:
      prefix: --refactor_NDN_cigar_string
      position: 2

  fix_misencoded_quality_scores:
    type: ['null', boolean]
    default: false
    doc: Fix mis-encoded base quality scores
    inputBinding:
      prefix: --fix_misencoded_quality_scores
      position: 2

  allow_potentially_misencoded_quality_scores:
    type: ['null', boolean]
    default: false
    doc: Ignore warnings about base quality score encoding
    inputBinding:
      prefix: --allow_potentially_misencoded_quality_scores
      position: 2

  useOriginalQualities:
    type: ['null', boolean]
    default: false
    doc: Use the base quality scores from the OQ tag
    inputBinding:
      prefix: --useOriginalQualities
      position: 2

  defaultBaseQualities:
    type:
    - 'null'
    - type: array
      items: string

    doc: Assign a default base quality
    inputBinding:
      prefix: --defaultBaseQualities
      position: 2

  performanceLog:
    type:
    - 'null'
    - type: array
      items: string

    doc: Write GATK runtime performance log to this file
    inputBinding:
      prefix: --performanceLog
      position: 2

  BQSR:
    type:
    - 'null'
    - type: array
      items: string

    doc: Input covariates table file for on-the-fly base quality score recalibration
    inputBinding:
      prefix: --BQSR
      position: 2

  disable_indel_quals:
    type: ['null', boolean]
    default: false
    doc: Disable printing of base insertion and deletion tags (with -BQSR)
    inputBinding:
      prefix: --disable_indel_quals
      position: 2

  emit_original_quals:
    type: ['null', boolean]
    default: false
    doc: Emit the OQ tag with the original base qualities (with -BQSR)
    inputBinding:
      prefix: --emit_original_quals
      position: 2

  preserve_qscores_less_than:
    type:
    - 'null'
    - type: array
      items: string

    doc: Don't recalibrate bases with quality scores less than this threshold (with
      -BQSR)
    inputBinding:
      prefix: --preserve_qscores_less_than
      position: 2

  globalQScorePrior:
    type:
    - 'null'
    - type: array
      items: string

    doc: Global Qscore Bayesian prior to use for BQSR
    inputBinding:
      prefix: --globalQScorePrior
      position: 2

  validation_strictness:
    type:
    - 'null'
    - type: array
      items: string

    doc: How strict should we be with validation (STRICT|LENIENT| SILENT)
    inputBinding:
      prefix: --validation_strictness
      position: 2

  remove_program_records:
    type: ['null', boolean]
    default: false
    doc: Remove program records from the SAM header
    inputBinding:
      prefix: --remove_program_records
      position: 2

  keep_program_records:
    type: ['null', boolean]
    default: false
    doc: Keep program records in the SAM header
    inputBinding:
      prefix: --keep_program_records
      position: 2

  sample_rename_mapping_file:
    type:
    - 'null'
    - type: array
      items: string

    doc: Rename sample IDs on-the-fly at runtime using the provided mapping file
    inputBinding:
      prefix: --sample_rename_mapping_file
      position: 2

  unsafe:
    type:
    - 'null'
    - type: array
      items: string

    doc: Enable unsafe operations - nothing will be checked at runtime (ALLOW_N_CIGAR_READS|
      ALLOW_UNINDEXED_BAM| ALLOW_UNSET_BAM_SORT_ORDER| NO_READ_ORDER_VERIFICATION|
      ALLOW_SEQ_DICT_INCOMPATIBILITY| LENIENT_VCF_PROCESSING|ALL)
    inputBinding:
      prefix: --unsafe
      position: 2

  sites_only:
    type: ['null', boolean]
    default: false
    doc: Just output sites without genotypes (i.e. only the first 8 columns of the
      VCF)
    inputBinding:
      prefix: --sites_only
      position: 2

  never_trim_vcf_format_field:
    type: ['null', boolean]
    default: false
    doc: Always output all the records in VCF FORMAT fields, even if some are missing
    inputBinding:
      prefix: --never_trim_vcf_format_field
      position: 2

  bam_compression:
    type:
    - 'null'
    - type: array
      items: string

    doc: Compression level to use for writing BAM files (0 - 9, higher is more compressed)
    inputBinding:
      prefix: --bam_compression
      position: 2

  simplifyBAM:
    type: ['null', boolean]
    default: false
    doc: If provided, output BAM files will be simplified to include just key reads
      for downstream variation discovery analyses (removing duplicates, PF-, non-primary
      reads), as well stripping all extended tags from the kept reads except the read
      group identifier
    inputBinding:
      prefix: --simplifyBAM
      position: 2

  disable_bam_indexing:
    type: ['null', boolean]
    default: false
    doc: Turn off on-the-fly creation of
    inputBinding:
      prefix: --disable_bam_indexing
      position: 2

  generate_md5:
    type: ['null', boolean]
    default: false
    doc: Enable on-the-fly creation of
    inputBinding:
      prefix: --generate_md5
      position: 2

  num_threads:
    type:
    - 'null'
    - string
    doc: Number of data threads to allocate to this analysis
    inputBinding:
      prefix: --num_threads
      position: 2

  num_cpu_threads_per_data_thread:
    type:
    - 'null'
    - string
    doc: Number of CPU threads to allocate per data thread
    inputBinding:
      prefix: --num_cpu_threads_per_data_thread
      position: 2

  monitorThreadEfficiency:
    type: ['null', boolean]
    default: false
    doc: Enable threading efficiency monitoring
    inputBinding:
      prefix: --monitorThreadEfficiency
      position: 2

  num_bam_file_handles:
    type:
    - 'null'
    - type: array
      items: string

    doc: Total number of BAM file handles to keep open simultaneously
    inputBinding:
      prefix: --num_bam_file_handles
      position: 2

  read_group_black_list:
    type:
    - 'null'
    - type: array
      items: string

    doc: Exclude read groups based on tags
    inputBinding:
      prefix: --read_group_black_list
      position: 2

  pedigree:
    type:
    - 'null'
    - type: array
      items: string

    doc: Pedigree files for samples
    inputBinding:
      prefix: --pedigree
      position: 2

  pedigreeString:
    type:
    - 'null'
    - type: array
      items: string

    doc: Pedigree string for samples
    inputBinding:
      prefix: --pedigreeString
      position: 2

  pedigreeValidationType:
    type:
    - 'null'
    - type: array
      items: string

    doc: Validation strictness for pedigree information (STRICT| SILENT)
    inputBinding:
      prefix: --pedigreeValidationType
      position: 2

  variant_index_type:
    type:
    - 'null'
    - type: array
      items: string

    doc: Type of IndexCreator to use for VCF/BCF indices (DYNAMIC_SEEK| DYNAMIC_SIZE|LINEAR|INTERVAL)
    inputBinding:
      prefix: --variant_index_type
      position: 2

  variant_index_parameter:
    type:
    - 'null'
    - type: array
      items: string

    doc: Parameter to pass to the VCF/BCF IndexCreator
    inputBinding:
      prefix: --variant_index_parameter
      position: 2

  logging_level:
    type:
    - 'null'
    - type: array
      items: string

    doc: Set the minimum level of logging
    inputBinding:
      prefix: --logging_level
      position: 2

  log_to_file:
    type:
    - 'null'
    - type: array
      items: string

    doc: Set the logging location
    inputBinding:
      prefix: --log_to_file
      position: 2

  out:
    type: string
    doc: An output file created by the walker. Will overwrite contents if file exists
    inputBinding:
      prefix: --out
      position: 2

  uncovered:
    type: ['null', boolean]
    default: false
    doc: output intervals that fail the coverage threshold instead
    inputBinding:
      prefix: --uncovered
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

  minMappingQuality:
    type:
    - 'null'
    - type: array
      items: string

    doc: The minimum allowable mapping quality score to be counted for coverage
    inputBinding:
      prefix: --minMappingQuality
      position: 2

  activityProfileOut:
    type:
    - 'null'
    - type: array
      items: string

    doc: Output the raw activity profile results in IGV format
    inputBinding:
      prefix: --activityProfileOut
      position: 2

  activeRegionOut:
    type:
    - 'null'
    - type: array
      items: string

    doc: Output the active region to this IGV formatted file
    inputBinding:
      prefix: --activeRegionOut
      position: 2

  activeRegionIn:
    type:
    - 'null'
    - type: array
      items: string

    doc: Use this interval list file as the active regions to process
    inputBinding:
      prefix: --activeRegionIn
      position: 2

  activeRegionExtension:
    type:
    - 'null'
    - type: array
      items: string

    doc: The active region extension; if not provided defaults to Walker annotated
      default
    inputBinding:
      prefix: --activeRegionExtension
      position: 2

  forceActive:
    type: ['null', boolean]
    default: false
    doc: If provided, all bases will be tagged as active
    inputBinding:
      prefix: --forceActive
      position: 2

  activeRegionMaxSize:
    type:
    - 'null'
    - type: array
      items: string

    doc: The active region maximum size; if not provided defaults to Walker annotated
      default
    inputBinding:
      prefix: --activeRegionMaxSize
      position: 2

  bandPassSigma:
    type:
    - 'null'
    - type: array
      items: string

    doc: The sigma of the band pass filter Gaussian kernel; if not provided defaults
      to Walker annotated default
    inputBinding:
      prefix: --bandPassSigma
      position: 2

  activeProbabilityThreshold:
    type:
    - 'null'
    - type: array
      items: string

    doc: Threshold for the probability of a profile state being active.
    inputBinding:
      prefix: --activeProbabilityThreshold
      position: 2

  filter_reads_with_N_cigar:
    type: ['null', boolean]
    default: false
    doc: filter out reads with CIGAR containing the N operator, instead of stop processing
      and report an error.
    inputBinding:
      prefix: --filter_reads_with_N_cigar
      position: 2

  filter_mismatching_base_and_quals:
    type: ['null', boolean]
    default: false
    doc: if a read has mismatching number of bases and base qualities, filter out
      the read instead of blowing up.
    inputBinding:
      prefix: --filter_mismatching_base_and_quals
      position: 2

  filter_bases_not_stored:
    type: ['null', boolean]
    default: false
    doc: if a read has no stored bases (i.e. a '*'), filter out the read instead of
      blowing up.
    inputBinding:
      prefix: --filter_bases_not_stored
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
