# Helix Filters

## Option 1: YAML

Note: The list order of the following fields must correspond to each other \(i.e., the 0th item in `pairs` matches the 0th item in `tumor_bam_files`, etc.\):

* `pairs`
* `normal_bam_files`
* `tumor_bam_files`
* `mutation_svs_txt_files`
* `mutation_svs_maf_files`

```yaml
tumor_bam_files:  # array of type "File"
  - class: File
    path: a/file/path
targets_list:  # type "File"
    class: File
    path: a/file/path
sample_summary_file:  # type "File" (optional)
    class: File
    path: a/file/path
request_pi: a_string  # type "string"
project_short_name: a_string  # type "string"
project_pi: a_string  # type "string"
project_name: a_string  # type "string"
project_id: a_string  # type "string"
project_description: a_string  # type "string"
pairs:  # array of 
    tumor_id: a_string  # type "string"
    snp_pileup:  # type "File"
        class: File
        path: a/file/path
    pair_maf:  # type "File"
        class: File
        path: a/file/path
    pair_id: a_string  # type "string"
    normal_id: a_string  # type "string"
normal_bam_files:  # array of type "File"
  - class: File
    path: a/file/path
mutation_svs_txt_files:  # array of type "File"
  - class: File
    path: a/file/path
mutation_svs_maf_files:  # array of type "File"
  - class: File
    path: a/file/path
microsatellites_file:  # type "File"
    class: File
    path: a/file/path
known_fusions_file:  # type "File"
    class: File
    path: a/file/path
is_impact: true  # default value of type "boolean".
helix_filter_version: a_string  # type "string"
extra_pi_groups: a_string  # type "string" (optional)
data_clinical_file:  # type "File"
    class: File
    path: a/file/path
cbio_segment_data_filename: a_string  # type "string"
cbio_mutation_data_filename: data_mutations_extended.txt  # default value of type "string".
cbio_meta_study_filename: meta_study.txt  # default value of type "string".
cbio_meta_mutations_filename: meta_mutations_extended.txt  # default value of type "string".
cbio_meta_fusions_filename: meta_fusions.txt  # default value of type "string".
cbio_meta_cna_segments_filename: a_string  # type "string"
cbio_meta_cna_filename: meta_CNA.txt  # default value of type "string".
cbio_fusion_data_filename: data_fusions.txt  # default value of type "string".
cbio_cna_scna_data_filename: data_CNA.scna.txt  # default value of type "string".
cbio_cna_data_filename: data_CNA.txt  # default value of type "string".
cbio_cna_ascna_data_filename: data_CNA.ascna.txt  # default value of type "string".
cbio_clinical_sample_meta_filename: meta_clinical_sample.txt  # default value of type "string".
cbio_clinical_sample_data_filename: data_clinical_sample.txt  # default value of type "string".
cbio_clinical_patient_meta_filename: meta_clinical_patient.txt  # default value of type "string".
cbio_clinical_patient_data_filename: data_clinical_patient.txt  # default value of type "string".
cbio_cases_sequenced_filename: cases_sequenced.txt  # default value of type "string".
cbio_cases_cnaseq_filename: cases_cnaseq.txt  # default value of type "string".
cbio_cases_cna_filename: cases_cna.txt  # default value of type "string".
cbio_cases_all_filename: cases_all.txt  # default value of type "string".
cancer_type: a_string  # type "string"
cancer_study_identifier: a_string  # type "string"
assay_coverage: a_string  # type "string"
argos_version_string: a_string  # type "string"
analysis_sv_filename: a_string  # type "string"
analysis_segment_cna_filename: a_string  # type "string"
analysis_mutations_share_filename: a_string  # type "string"
analysis_mutations_filename: a_string  # type "string"
analysis_gene_cna_filename: a_string  # type "string"
IMPACT_gene_list:  # type "File"
    class: File
    path: a/file/path
```

An example yaml file could look like this

```yaml
IMPACT_gene_list:
  class: File
  path: /work/ci/helix_filters_01/reference_data/gene_lists/all_IMPACT_genes.tsv
analysis_gene_cna_filename: demo.gene.cna.txt
analysis_mutations_filename: demo.muts.maf
analysis_mutations_share_filename: demo.muts.share.maf
analysis_segment_cna_filename: demo.seg.cna.txt
analysis_sv_filename: demo.svs.maf
argos_version_string: 2.x
assay_coverage: '1000'
cancer_study_identifier: demo
cancer_type: MEL
cbio_meta_cna_segments_filename: Proj_08390_G_meta_cna_hg19_seg.txt
cbio_segment_data_filename: Proj_08390_G_data_cna_hg19.seg
data_clinical_file:
  class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/inputs/demo_sample_data_clinical.txt
helix_filter_version: 20.06.1
is_impact: true
known_fusions_file:
  class: File
  path: /juno/work/ci/vurals/run_CWL_in_command_line/Helix_filters/pluto-cwl/ref/known_fusions_at_mskcc.txt
microsatellites_file:
  class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/microsatellites/microsatellites.head500000.list
mutation_svs_maf_files:
- class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/maf/Sample1.Sample2.svs.pass.vep.maf
mutation_svs_txt_files:
- class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/maf/Sample1.Sample2.svs.pass.vep.portal.txt
normal_bam_files:
- class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/bam/Sample2.bam
pairs:
- normal_id: Sample2
  pair_id: Sample1.Sample2
  pair_maf:
    class: File
    path: /juno/work/ci/helix_filters_01/fixtures/demo/maf/Sample1.Sample2.muts.maf
  snp_pileup:
    class: File
    path: /juno/work/ci/helix_filters_01/fixtures/demo/snp-pileup/Sample1.Sample2.snp_pileup.gz
  tumor_id: Sample1
project_description: project
project_id: demo
project_name: demo
project_pi: Dr. Jones
project_short_name: demo
request_pi: Dr. Franklin
sample_summary_file:
  class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/qc/demo_SampleSummary.txt
targets_list:
  class: File
  path: /juno/work/ci/resources/roslin_resources/targets/HemePACT_v4/b37/HemePACT_v4_b37_targets.ilist
tumor_bam_files:
- class: File
  path: /juno/work/ci/helix_filters_01/fixtures/demo/bam/Sample1.bam
```

Using this example yaml file, workflow could be run with the command below

```bash
toil-cwl-runner \
    --singularity \
    --batchSystem single_machine \
    --disableCaching \
    --preserve-environment SINGULARITY_DOCKER_USERNAME SINGULARITY_DOCKER_PASSWORD \
    --outdir my_output_directory \
    pluto-cwl/cwl/workflow_with_facets.cwl my_input.yaml
```

## Option 2: Command Line Arguments

```bash
toil-cwl-runner 

usage: cwl/workflow_with_facets.cwl [-h] --IMPACT_gene_list IMPACT_GENE_LIST
                                    --analysis_gene_cna_filename
                                    ANALYSIS_GENE_CNA_FILENAME
                                    --analysis_mutations_filename
                                    ANALYSIS_MUTATIONS_FILENAME
                                    --analysis_mutations_share_filename
                                    ANALYSIS_MUTATIONS_SHARE_FILENAME
                                    --analysis_segment_cna_filename
                                    ANALYSIS_SEGMENT_CNA_FILENAME
                                    --analysis_sv_filename
                                    ANALYSIS_SV_FILENAME
                                    --argos_version_string
                                    ARGOS_VERSION_STRING --assay_coverage
                                    ASSAY_COVERAGE --cancer_study_identifier
                                    CANCER_STUDY_IDENTIFIER --cancer_type
                                    CANCER_TYPE
                                    [--cbio_cases_all_filename CBIO_CASES_ALL_FILENAME]
                                    [--cbio_cases_cna_filename CBIO_CASES_CNA_FILENAME]
                                    [--cbio_cases_cnaseq_filename CBIO_CASES_CNASEQ_FILENAME]
                                    [--cbio_cases_sequenced_filename CBIO_CASES_SEQUENCED_FILENAME]
                                    [--cbio_clinical_patient_data_filename CBIO_CLINICAL_PATIENT_DATA_FILENAME]
                                    [--cbio_clinical_patient_meta_filename CBIO_CLINICAL_PATIENT_META_FILENAME]
                                    [--cbio_clinical_sample_data_filename CBIO_CLINICAL_SAMPLE_DATA_FILENAME]
                                    [--cbio_clinical_sample_meta_filename CBIO_CLINICAL_SAMPLE_META_FILENAME]
                                    [--cbio_cna_ascna_data_filename CBIO_CNA_ASCNA_DATA_FILENAME]
                                    [--cbio_cna_data_filename CBIO_CNA_DATA_FILENAME]
                                    [--cbio_cna_scna_data_filename CBIO_CNA_SCNA_DATA_FILENAME]
                                    [--cbio_fusion_data_filename CBIO_FUSION_DATA_FILENAME]
                                    [--cbio_meta_cna_filename CBIO_META_CNA_FILENAME]
                                    --cbio_meta_cna_segments_filename
                                    CBIO_META_CNA_SEGMENTS_FILENAME
                                    [--cbio_meta_fusions_filename CBIO_META_FUSIONS_FILENAME]
                                    [--cbio_meta_mutations_filename CBIO_META_MUTATIONS_FILENAME]
                                    [--cbio_meta_study_filename CBIO_META_STUDY_FILENAME]
                                    [--cbio_mutation_data_filename CBIO_MUTATION_DATA_FILENAME]
                                    --cbio_segment_data_filename
                                    CBIO_SEGMENT_DATA_FILENAME
                                    --data_clinical_file DATA_CLINICAL_FILE
                                    [--extra_pi_groups EXTRA_PI_GROUPS]
                                    --helix_filter_version
                                    HELIX_FILTER_VERSION [--is_impact]
                                    --known_fusions_file KNOWN_FUSIONS_FILE
                                    --microsatellites_file
                                    MICROSATELLITES_FILE
                                    --mutation_svs_maf_files
                                    MUTATION_SVS_MAF_FILES
                                    --mutation_svs_txt_files
                                    MUTATION_SVS_TXT_FILES --normal_bam_files
                                    NORMAL_BAM_FILES --pairs PAIRS
                                    --project_description PROJECT_DESCRIPTION
                                    --project_id PROJECT_ID --project_name
                                    PROJECT_NAME --project_pi PROJECT_PI
                                    --project_short_name PROJECT_SHORT_NAME
                                    --request_pi REQUEST_PI
                                    [--sample_summary_file SAMPLE_SUMMARY_FILE]
                                    --targets_list TARGETS_LIST
                                    --tumor_bam_files TUMOR_BAM_FILES
                                    [job_order]
```

## Option 3: Isolated Run

Helix filters can also be run alone using the repo's `run.py` script; see [https://github.com/mskcc/pluto-cwl](https://github.com/mskcc/pluto-cwl)

