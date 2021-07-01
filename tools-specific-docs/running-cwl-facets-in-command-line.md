# Facets

### Getting the CWL

The CWL is available from the pluto-cwl repository: 

[https://github.com/mskcc/pluto-cwl/blob/master/cwl/run-facets-wrapper.cwl](https://github.com/mskcc/pluto-cwl/blob/master/cwl/run-facets-wrapper.cwl)

### Option 1: Running with yaml generated through cwltool

Create a template yaml, as defined by the CWL:

```text
cwltool --make-template pluto-cwl/cwl/run-facets-legacy-wrapper.cwl > my_input.yaml
```

Skipping the optional arguments, minimal `my_input.yaml` file could look like the following:

```text
snp_pileup: # type “File”
  class: File
  path: /work/ci/vurals/run_CWL_in_command_line/Facets2/s_C_YX2WXJ_N001_d__s_C_YX2WXJ_P001_d.snp_pileup.gz
seed: “1000" # default value of type “string”. (optional)
sample_id: “abc” # type “string”
purity_min_nhet: “25" # default value of type “string”. (optional)
purity_cval: “100" # default value of type “string”. (optional)
min_nhet: “25" # default value of type “string”. (optional)
cval: “50" # default value of type “string”. (optional)
```

```python
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    --preserve-environment SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD \
    --outdir my_output_directory \
    run-facets-legacy-wrapper.cwl my_input.yaml
```

## Option 2: Running tool directly through Command Line arguments

To view usage arguments to pass to the CWL, do

```text
toil-cwl-runner run-facets-legacy-wrapper.cwl

usage: run-facets-legacy-wrapper.cwl [-h] [--cval CVAL] [--min_nhet MIN_NHET]
                                     [--purity_cval PURITY_CVAL]
                                     [--purity_min_nhet PURITY_MIN_NHET]
                                     --sample_id SAMPLE_ID [--seed SEED]
                                     --snp_pileup SNP_PILEUP
                                     [job_order]

```

Example run \(omits optional arguments\):

```bash
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    --preserve-environment SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD \
    --outdir my_output_directory \
    pluto-cwl/cwl/run-facets-legacy-wrapper.cwl \
    --snp_pileup /work/ci/vurals/run_CWL_in_command_line/Facets/s_C_YX2WXJ_N001_d__s_C_YX2WXJ_P001_d.snp_pileup.gz \
    --sample_id abc \
    --seed 1000 \
    --purity_min_nhet 25 \
    --purity_cval 100 \
    --min_nhet 25 \
    --cval 50
```

