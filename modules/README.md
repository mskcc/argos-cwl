# modules

### pair

For processing pairs of samples, such as alignment, realignment, and variant calling.

### project

For processing at the "project" level; the `generate-qc.cwl` is a pipeline that creates QC files from multiple pairs of samples.

### sample

For processing at the sample level. These CWLs use `picard` and `gatk` to make metrics.
