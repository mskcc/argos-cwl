# Running CWL in Command Line

## Prerequisite

* A CWL
* Access to JUNO cluster
  * We use `silo.mskcc.org`
* Load Singularity version 3.7.1
  * `module load singularity/3.7.1`
* Load python 3.7.1
  * `module load python/3.7.1`
* Export environment variables:
  * `export SINGULARITY_CACHEDIR=<my_cache_dir>`
    * For voyager we use `/juno/work/ci/singularity_cache_3_7_1/`
  * `export SINGULARITY_DOCKER_USERNAME=mskccvoyager`
  * `export SINGULARITY_DOCKER_PASSWORD=<redacted>`
* A python virtualenv with toil 5.4.x installed
  * If you don't already have one, see [_Install Toil into a Python Virtual Environment_ ](initial-setup.md#install-toil-into-a-python-virtual-environment-or-venv)_\(or venv\)_
* Node.js installed
  * Check if you have node installed with `node -v` ; if not, see [Install Node.js](initial-setup.md#install-node-js)

## Get/git ARGOS CWL 

Get the CWL and `git clone` it to your desired working directory from github:

```python
git clone https://github.com/mskcc/argos-cwl
```

This will put `argos-cwl` into a a subdirectory in your work directory named `argos-cwl`.

## Running CWL commands with toil-cwl-runner

Explain toil-cwl-runner

#### Prerequisite

* A python virtual envionment/venv; assuming it's set to `VENV_PATH` -`activate` with toil installed:
  * `source $VENV_PATH/bin/activate`
* A CWL in your working directory; we will use [CMO-Fillout](https://github.com/mskcc/argos-cwl/blob/master/tools/cmo-utils/1.9.15/cmo-fillout.cwl) as an example, retrieved from [above](running-cwl-in-command-line.md#get-git-argos-cwl)
* Input files for the CWL
  * Test input: `/work/ci/vurals/test_fillout4/`
  * Add inputs to SINGULARITY\_BIND env variable so that singularity has access to them at runtime:
    * `export SINGULARITY_BIND=<input_path1,input_path2>`
    * `Example: export SINGULARITY_BIND="/work,/juno"`

### Option 1: Running with yaml generated through cwltool

Create a template yaml, as defined by the CWL:

```text
cwltool --make-template argos-cwl/tools/cmo-utils/1.9.15/cmo-fillout.cwl > my_input.yaml
```

The `my_input.yaml` file should look like the following:

```text
ref_fasta:  # type "File"
    class: File
    path: a/file/path
portal_output: a_string  # type "string" (optional)
pairing:  # type "File" (optional)
    class: File
    path: a/file/path
output_format: a_string  # type "string"
output: a_string  # type "string" (optional)
maf:  # type "File"
    class: File
    path: a/file/path
fillout: a_string  # type "string" (optional)
bams:  # array of 
  - a_string  # type "string"
  - # type "File"
    class: File
    path: a/file/path
```

Configure `my_input.yaml` with the the input data for our test - optional fields can and should be deleted or commented out if they will not be used:

```text
ref_fasta:  # type "File"
    class: File
    path: /work/ci/vurals/test_fillout4/GRCh37/b37.fasta
# portal_output: a_string  # type "string" (optional)
pairing:  # type "File" (optional)
    class: File
    path: /work/ci/vurals/test_fillout4/sample_pairing.txt
output_format: "1"  # type "string"
# output: a_string  # type "string" (optional)
maf:  # type "File"
    class: File
    path: /work/ci/vurals/test_fillout4/s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.maf
# fillout: a_string  # type "string" (optional)
bams:  # array of 
  - # type "File"
    class: File
    path: /work/ci/vurals/test_fillout4/s_C_000516_N901_dZ_IM6.rg.md.abra.printreads.bam
  - class: File
    path: /work/ci/vurals/test_fillout4/s_SK_MEL_1106A_CL_P11_09483F.rg.md.abra.printreads.bam
```

_Note: `bams` is an array of `File` OR an array of `string`, or some combination of both. When specifying a list, make sure it adheres to standard YAML syntax: a list can be denoted by a leading hyphen \(-\) or the elements in the list can be specified by enclosing brackets._

You can then run this with

```python
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    --preserve-environment SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD \
    --outdir my_output_directory \
    argos-cwl/tools/cmo-utils/1.9.15/cmo-fillout.cwl my_input.yaml
```

### Option 2: Running through command line arguments

#### Usage

To view usage arguments to pass to the CWL, do

```python
toil-cwl-runner argos-cwl/tools/cmo-utils/1.9.15/cmo-fillout.cwl

usage: argos-cwl/tools/cmo-utils/1.9.15/cmo-fillout.cwl [-h] --bams BAMS
                                                        [--fillout FILLOUT]
                                                        --maf MAF
                                                        [--output OUTPUT]
                                                        --output_format
                                                        OUTPUT_FORMAT
                                                        [--pairing PAIRING]
                                                        [--portal_output PORTAL_OUTPUT]
                                                        --ref_fasta REF_FASTA
                                                        [job_order]

```

#### Example Run

Note: If you need to list an array of files, you can do so by specifying the arguments multiple times. See "bams in this example below:

```python
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    --preserve-environment SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD \
    --outdir my_output_directory \
    argos-cwl/tools/cmo-utils/1.9.15/cmo-fillout.cwl \
    --bams /work/ci/vurals/test_fillout4/s_C_000516_N901_dZ_IM6.rg.md.abra.printreads.bam \
    --bams /work/ci/vurals/test_fillout4/s_SK_MEL_1106A_CL_P11_09483F.rg.md.abra.printreads.bam \
    --maf /work/ci/vurals/test_fillout4/s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.maf \
    --output_format 1 \
    --ref_fasta /work/ci/vurals/test_fillout4/GRCh37/b37.fasta \
    --pairing /work/ci/vurals/test_fillout4/sample_pairing.txt
```

Single Machine:

```text
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    ...
```

LSF:

```text
toil-cwl-runner \
    --singularity \
    --batchSystem lsf \
    --disableCaching \
    ...
```

#### Getting outputs

When your run finishes you will get:

```text
{
    "fillout_out": {
        "location": "file:///juno/work/ci/nikhil/example_run/my_output_directory/s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.fillout",
        "basename": "s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.fillout",
        "nameroot": "s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts",
        "nameext": ".fillout",
        "class": "File",
        "checksum": "sha1$805e084b6d2db7b90c857d10e7153882ce7d7ce1",
        "size": 1572304
    },
    "portal_fillout": {
        "location": "file:///juno/work/ci/nikhil/example_run/my_output_directory/s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.fillout.portal.maf",
        "basename": "s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.fillout.portal.maf",
        "nameroot": "s_SK_MEL_1106A_CL_P11_09483F.s_C_000516_N901_dZ_IM6.muts.fillout.portal",
        "nameext": ".maf",
        "class": "File",
        "checksum": "sha1$6ef3d3867d5389b2e9eb0efe1d1e0389bbabb59c",
        "size": 6187721
    }
}[2021-06-03T15:11:49-0400] [MainThread] [I] [toil.common] Successfully deleted the job store: FileJobStore(/scratch/tmpfbed637q)
```

