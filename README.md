# Argos-cwl

CWLs for the Argos pipeline.

The CWLs are categorized in multiple directories based on their unit of work, although the CWLs contained within can refer to other CWL directories via their relative path.

For example, each CWL module that performs at the tumor-normal pair level are contained in the `modules/pair` directory; workflows that perform executions by chaining multiple modules are contained in the `workflows` directory. The CWLs in `workflows/` will reference CWLs in `modules/pair/` to perform their tasks, such as `alignment-pair.cwl` and `variant-calling.cwl`.

## Set up

This repo contains git submodules; make sure to `git clone --recursive` when downloading.

CWLs have been tested with the `toil` executor, found [here](https://github.com/DataBiosphere/toil).

## Directories

#### modules/

Module CWLs perform small pipeline operations to do a particular task. For example, `modules/pair/alignment.cwl` will takes a pair of tumor-normal samples and  align it with `bwa mem`, followed by `modules/pair/realignment.cwl`; this then returns a pair of tumor-normal bam files and some metrics.

Multiple CWLs in this directory will refer to other CWLs in the `workflows/` and `tools/` directories.

#### tools/

Contains CWLs for tools (`bwa`, `bcftools`, etc.) used by the modules and workflows.

#### workflows/

Workflow CWLs that operate at either a sample level or at one paired tumor-normal level. Multiple CWLs in this directory will refer to other CWLs in the `modules/` and `tools/` directories.

## CWLs

The two CWLs listed here expect input as a list of paired tumor-normal samples.

#### project-workflow.cwl

Given a list of paired tumor-normal samples, this CWL uses `workflows/pair-workflow.cwl` to do alignment, variant calling, and some metrics, followed by `modules/project/generate-qc.cwl` to compile QC data.

#### project-workflow-sv.cwl

Similar to `project-workflow.cwl`, given a list of paired tumor-normal samples, this CWL uses `workflows/pair-workflow-sv.cwl` to do alignment, variant calling (including structural variants), and some metrics, followed by `modules/project/generate-qc.cwl` to compile QC data for all tumor-normal pairs.
