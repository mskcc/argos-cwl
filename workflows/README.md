# workflows

Contains three "workflow" CWLs.

### sample-workflow.cwl

Processes a sample by:
- Checking if it's a PDX; if so, disambiguate between human and mouse data
- Checks if it's a bam; if so, extract fastqs from bams
- Perform `bwa mem`, `MarkDuplicates`, and gather metrics

### pair-workflow.cwl

This workflow scatters a tumor-normal pair of samples into two separate `sample-workflow.cwl` runs.

### pair-workflow-sv.cwl

Performs the same methods as `pair-workflow.cwl`, except it adds structural variant calling with `delly`.

### copy-outputs.cwl

Reorganizes the output of the pair workflows into a delivery friendly output structure
