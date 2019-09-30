#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
baseCommand:
  - perl
  - /usr/bin/vcf2maf/vcf2maf.pl

label: vcf2maf

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 8000
    coresMin: 2
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-vcf2maf:1.6.17

doc: |
  None

inputs:
  cache_version:
    type:
    - 'null'
    - string
    default: '86'
    doc: Version of VEP and its cache to use
    inputBinding:
      prefix: --cache-version
  species:
    type:
    - 'null'
    - string
    default: homo_sapiens
    doc: Species of variants in input
    inputBinding:
      prefix: --species
  ncbi_build:
    type:
    - 'null'
    - string
    default: GRCh37
    doc: Genome build of variants in input
    inputBinding:
      prefix: --ncbi-build
  ref_fasta:
    type: ['null', File]
    doc: Reference FASTA file
    inputBinding:
      prefix: --ref-fasta
  maf_center:
    type: ['null', string]
    default: mskcc.org
    doc: Variant calling center to report in MAF
    inputBinding:
      prefix: --maf-center
  output_maf:
    type: ['null', string]
    doc: Path to output MAF file
    inputBinding:
      prefix: --output-maf
  max_filter_ac:
    type:
    - 'null'
    - int
    default: 10
    doc: Use tag common_variant if the filter-vcf reports a subpopulation AC higher
      than this
    inputBinding:
      prefix: --max-filter-ac
  min_hom_vaf:
    type:
    - 'null'
    - float
    default: 0.7
    doc: If GT undefined in VCF, minimum allele fraction to call a variant homozygous
    inputBinding:
      prefix: --min-hom-vaf
  remap_chain:
    type: ['null', string]
    doc: Chain file to remap variants to a different assembly before running VEP
    inputBinding:
      prefix: --remap-chain
  normal_id:
    type: ['null', string]
    default: NORMAL
    doc: Matched_Norm_Sample_Barcode to report in the MAF
    inputBinding:
      prefix: --normal-id
  buffer_size:
    type:
    - 'null'
    - int
    default: 5000
    doc: Number of variants VEP loads at a time; Reduce this for low memory systems
    inputBinding:
      prefix: --buffer-size
  custom_enst:
    type: ['null', string]
    doc: List of custom ENST IDs that override canonical selection
    inputBinding:
      prefix: --custom-enst
  vcf_normal_id:
    type: ['null', string]
    default: NORMAL
    doc: Matched normal ID used in VCFs genotype columns
    inputBinding:
      prefix: --vcf-normal-id
  vep_path:
   type: ['null', string]
   doc: Folder containing variant_effect_predictor.pl or vep binary
   inputBinding:
     prefix: --vep-path
  vep_data:
    type: ['null', string]
    doc: VEPs base cache/plugin directory
    inputBinding:
      prefix: --vep-data
  any_allele:
    type: ['null', string]
    doc: When reporting co-located variants, allow mismatched variant alleles too
    inputBinding:
      prefix: --any-allele
  tmp_dir:
    type: ['null', string]
    doc: Folder to retain intermediate VCFs after runtime
    inputBinding:
      prefix: --tmp-dir
  input_vcf:
    type:
    - string
    - File
    doc: Path to input file in VCF format
    inputBinding:
      prefix: --input-vcf
  vep_forks:
    type:
    - 'null'
    - int
    default: 4
    doc: Number of forked processes to use when running VEP
    inputBinding:
      prefix: --vep-forks
  vcf_tumor_id:
    type: ['null', string]
    default: TUMOR
    doc: Tumor sample ID used in VCFs genotype columns
    inputBinding:
      prefix: --vcf-tumor-id
  tumor_id:
    type: ['null', string]
    default: TUMOR
    doc: Tumor_Sample_Barcode to report in the MAF
    inputBinding:
      prefix: --tumor-id
  filter_vcf:
    type:
    - 'null'
    - string
    - File
    doc: The non-TCGA VCF from exac.broadinstitute.org
    inputBinding:
      prefix: --filter-vcf
    secondaryFiles:
    - .tbi
  retain_info:
    type: ['null', string]
    doc: Comma-delimited names of INFO fields to retain as extra columns in MAF
    inputBinding:
      prefix: --retain-info
  retain_fmt:
    type: ['null', string]
    doc: Comma-delimited names of FORMAT fields to retain as extra columns in MAF []
    inputBinding:
      prefix: --retain-fmt
outputs:
  output:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output_maf)
            return inputs.output_maf;
          return null;
        }
