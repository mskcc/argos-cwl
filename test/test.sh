#!/bin/bash

set -eu
PROCESS_LIST=()

run_test() {
	mkdir -p ${1}/${2}/work
	mkdir -p ${1}/${2}/out
	mkdir -p ${1}/${2}/tmp
	toil-cwl-runner --singularity --logFile ${1}/${2}/toil_log.log --coalesceStatusCalls --debug --clean never --disableCaching --batchSystem lsf --doubleMem  --disable-user-provenance --disable-host-provenance --preserve-environment PATH TMPDIR TOIL_LSF_ARGS SINGULARITY_PULLDIR SINGULARITY_CACHEDIR PWD SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD SINGULARITYENV_LC_ALL --defaultMemory 8G --maxCores 16 --maxDisk 128G --maxMemory 256G --not-strict --realTimeLogging  --jobStore ${1}/${2}/jobstore --tmpdir-prefix ${1}/${2}/tmp --workDir ${1}/${2}/work --outdir ${1}/${2}/out --maxLocalJobs 500 ${3} ${4} &
	PROCESS_LIST+=($!)
}

# Test the SV cwl

run_test $1 sv ../project-workflow-sv.cwl inputs.yaml

# Test the non SV cwl

# run_test $1 non_sv ../project-workflow.cwl inputs.yaml

# Test the copy outputs cwl

run_test $1 copy_outputs ../workflows/copy_outputs.cwl copy_outputs.yaml

# Test the copy outputs cwl without meta

run_test $1 copy_outputs_without_meta ../workflows/copy_outputs.cwl copy_outputs_without_meta.yaml

for SINGLE_PROCESS in "${PROCESS_LIST[@]}"; do
  wait "$SINGLE_PROCESS"
done
