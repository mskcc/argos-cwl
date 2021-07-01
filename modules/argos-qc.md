# Argos QC

## Option 1: YAML

```bash
tumor_sample_names:  # array of type "string"
  - a_string
tumor_bams:  # array of type "File"
  - class: File
    path: a/file/path
ref_fasta:  # type "File"
    class: File
    path: a/file/path
qual_metrics:  # array of array of type "File"
    class: File
    path: a/file/path
project_prefix: a_string  # type "string"
pi_email: a_string  # type "string"
pi: a_string  # type "string"
per_target_coverage:  # array of array of type "File"
    class: File
    path: a/file/path
normal_sample_names:  # array of type "string"
  - a_string
normal_bams:  # array of type "File"
  - class: File
    path: a/file/path
md_metrics:  # array of array of type "File"
    class: File
    path: a/file/path
mafs:  # array of type "File"
  - class: File
    path: a/file/path
insert_metrics:  # array of array of type "File"
    class: File
    path: a/file/path
hs_metrics:  # array of array of type "File"
    class: File
    path: a/file/path
hotspot_list_maf:  # type "File"
    class: File
    path: a/file/path
genome: a_string  # type "string"
fp_genotypes:  # type "File"
    class: File
    path: a/file/path
files:  # array of type "File"
  - class: File
    path: a/file/path
doc_basecounts:  # array of array of type "File"
    class: File
    path: a/file/path
directories:  # array of type "Directory"
  - class: Directory
    path: a/directory/path
conpair_pileups:  # array of array of type "File"
    class: File
    path: a/file/path
conpair_markers: a_string  # type "string"
assay: a_string  # type "string"
```

## Option 2: Command Line Arguments

```bash
toil-cwl-runner argos-cwl/modules/project/generate-qc-sv.cwl

usage: generate-qc-sv.cwl [-h] --assay ASSAY --conpair_markers CONPAIR_MARKERS
                          --conpair_pileups CONPAIR_PILEUPS --directories
                          DIRECTORIES --doc_basecounts DOC_BASECOUNTS --files
                          FILES --fp_genotypes FP_GENOTYPES --genome GENOME
                          --hotspot_list_maf HOTSPOT_LIST_MAF --hs_metrics
                          HS_METRICS --insert_metrics INSERT_METRICS --mafs
                          MAFS --md_metrics MD_METRICS --normal_bams
                          NORMAL_BAMS --normal_sample_names
                          NORMAL_SAMPLE_NAMES --per_target_coverage
                          PER_TARGET_COVERAGE --pi PI --pi_email PI_EMAIL
                          --project_prefix PROJECT_PREFIX --qual_metrics
                          QUAL_METRICS --ref_fasta REF_FASTA --tumor_bams
                          TUMOR_BAMS --tumor_sample_names TUMOR_SAMPLE_NAMES
                          [job_order]

```

## 

