#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
baseCommand:
- /usr/bin/vardict/bin/VarDict
id: vardict

arguments:
- position: 1
  prefix: -b
  valueFrom: "${\n    return inputs.b.path + \"|\" + inputs.b2.path;\n}"
- position: 0
  prefix: -N
  valueFrom: "${\n    if (inputs.N2)\n        return [inputs.N, inputs.N2];\n    else\n\
    \        return inputs.N;\n}"


requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 4
    ramMin: 24000
  DockerRequirement:
    dockerPull: mskcc/roslin-variant-vardict:1.5.1

inputs:

  B:
    type: int?
    doc: The minimum
    inputBinding:
      position: 0
      prefix: -B

  C:
    type: boolean?
    doc: Indicate the chromosome names are just numbers, such as 1, 2, not chr1, chr2
    inputBinding:
      position: 0
      prefix: -C

  D:
    type: boolean?
    doc: Debug mode. Will print some error messages and append full genotype at the end.
    inputBinding:
      position: 0
      prefix: -D

  E:
    type: string?
    doc: The column for region end, e.g. gene end
    inputBinding:
      position: 0
      prefix: -E

  F:
    type: string?
    doc: The hexical to filter reads using samtools. Default - 0x500 (filter 2nd alignments and duplicates). Use -F 0 to turn it off.
    inputBinding:
      position: 0
      prefix: -F

  G:
    type: File
    secondaryFiles:
      - .fai
    inputBinding:
      position: 0
      prefix: -G

  H:
    type: boolean?
    doc: Print this help page
    inputBinding:
      position: 0
      prefix: -H

  I:
    type: string?
    doc: The indel size. Default - 120bp
    inputBinding:
      position: 0
      prefix: -I

  M:
    type: string?
    doc: The minimum matches for a read to be considered. If, after soft-clipping, the matched bp is less than INT, then the read is discarded. It's meant for PCR based targeted sequencing where there's no insert and the matching is only the primers. Default - 0, or no filtering
    inputBinding:
      position: 0
      prefix: -M

  N:
    type: string?
    doc: Tumor Sample Name

  N2:
    type: string?
    doc: Normal Sample Name

  O:
    type: string?
    doc: The reads should have at least mean MapQ to be considered a valid variant. Default - no filtering
    inputBinding:
      position: 0
      prefix: -O

  P:
    type: string?
    doc: The read position filter. If the mean variants position is less that specified, it's considered false positive. Default - 5
    inputBinding:
      position: 0
      prefix: -P

  Q:
    type: string?
    doc: If set, reads with mapping quality less than INT will be filtered and ignored
    inputBinding:
      position: 0
      prefix: -Q

  R:
    type: string?
    doc: The region of interest. In the format of chr -start-end. If end is omitted, then a single position. No BED is needed.
    inputBinding:
      position: 0
      prefix: -R

  S:
    type: string?
    doc: The column for region start, e.g. gene start
    inputBinding:
      position: 0
      prefix: -S

  T:
    type: string?
    doc: Trim bases after [INT] bases in the reads
    inputBinding:
      position: 0
      prefix: -T

  V:
    type: string?
    doc: The lowest frequency in normal sample allowed for a putative somatic mutations. Default to 0.05
    inputBinding:
      position: 0
      prefix: -V

  VS:
    type: string?
    doc: How strict to be when reading a SAM or BAM. STRICT - throw an exception if something looks wrong. LENIENT - Emit warnings but keep going if possible. SILENT - Like LENIENT, only don't emit warning messages. Default - LENIENT
    inputBinding:
      position: 0
      prefix: -VS

  X:
    type: string?
    doc: Extension of bp to look for mismatches after insersion or deletion. Default to 3 bp, or only calls when they're within 3 bp.
    inputBinding:
      position: 0
      prefix: -X

  Z:
    type: string?
    doc: For downsampling fraction. e.g. 0.7 means roughly 70%% downsampling. Default - No downsampling. Use with caution. The downsampling will be random and non-reproducible.
    inputBinding:
      position: 0
      prefix: -Z

  a:
    type: string?
    doc: Indicate it's amplicon based calling. Reads don't map to the amplicon will be skipped. A read pair is considered belonging the amplicon if the edges are less than int bp to the amplicon, and overlap fraction is at least float. Default - 10 -0.95
    inputBinding:
      position: 0
      prefix: -a

  b:
    type: File
    secondaryFiles:
      - .bai
    doc: Tumor bam

  b2:
    type: File
    secondaryFiles:
      - .bai
    doc: Normal bam

  bedfile:
    type: File?
    inputBinding:
      position: 1

  c:
    type: string?
    doc: The column for chromosome
    inputBinding:
      position: 0
      prefix: -c

  d:
    type: string?
    doc: The delimiter for split region_info, default to tab "\t"
    inputBinding:
      position: 0
      prefix: -d

  e:
    type: string?
    doc: The column for segment ends in the region, e.g. exon ends
    inputBinding:
      position: 0
      prefix: -e

  f:
    type: string?
    doc: The threshold for allele frequency, default - 0.05 or 5%%
    inputBinding:
      position: 0
      prefix: -f

  g:
    type: string?
    doc: The column for gene name, or segment annotation
    inputBinding:
      position: 0
      prefix: -g

  h:
    type: boolean?
    doc: Print a header row decribing columns
    inputBinding:
      position: 0
      prefix: -hh

  i:
    type: boolean?
    doc: Output splicing read counts
    inputBinding:
      position: 0
      prefix: -i

  k:
    type: string?
    doc: Indicate whether to perform local realignment. Default - 1. Set to 0 to disable it. For Ion or PacBio, 0 is recommended.
    inputBinding:
      position: 0
      prefix: -k

  m:
    type: string?
    doc: If set, reads with mismatches more than INT will be filtered and ignored. Gaps are not counted as mismatches. Valid only for bowtie2/TopHat or BWA aln followed by sampe. BWA mem is calculated as NM - Indels. Default - 8, or reads with more than 8 mismatches will not be used.
    inputBinding:
      position: 0
      prefix: -m

  n:
    type: string?
    doc: The regular expression to extract sample name from bam filenames. Default to - /([^\/\._]+?)_[^\/]*.bam/
    inputBinding:
      position: 0
      prefix: -n

  o:
    type: string?
    doc: The Qratio of (good_quality_reads)/(bad_quality_reads+0.5). The quality is defined by -q option. Default - 1.5
    inputBinding:
      position: 0
      prefix: -o

  p:
    type: boolean?
    doc: Do pileup regarless the frequency
    inputBinding:
      position: 0
      prefix: -p

  q:
    type: string?
    doc: The phred score for a base to be considered a good call. Default - 25 (for Illumina) For PGM, set it to ~15, as PGM tends to under estimate base quality.
    inputBinding:
      position: 0
      prefix: -q

  r:
    type: string?
    doc: The minimum
    inputBinding:
      position: 0
      prefix: -r

  s:
    type: string?
    doc: The column for segment starts in the region, e.g. exon starts
    inputBinding:
      position: 0
      prefix: -s

  t:
    type: boolean?
    doc: Indicate to remove duplicated reads. Only one pair with same start positions will be kept
    inputBinding:
      position: 0
      prefix: -t

  th:
    type: string?
    doc: Threads count.
    inputBinding:
      position: 0
      prefix: -th

  three:
    type: boolean?
    doc: Indicate to move indels to 3-prime if alternative alignment can be achieved.
    inputBinding:
      position: 0
      prefix: '-3'

  x:
    type: string?
    doc: The number of nucleotide to extend for each segment, default - 0 -y
    inputBinding:
      position: 0
      prefix: -x

  z:
    type: string?
    doc: Indicate wehther is zero-based cooridates, as IGV does. Default - 1 for BED file or amplicon BED file. Use 0 to turn it off. When use -R option, it's set to 0AUTHOR. Written by Zhongwu Lai, AstraZeneca, Boston, USAREPORTING BUGS. Report bugs to zhongwu@yahoo.comCOPYRIGHT. This is free software - you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
    inputBinding:
      position: 0
      prefix: -z

outputs:
  output:
    type: File
    outputBinding:
      glob: vardict_app_output.vcf


stdout: vardict_app_output.vcf
