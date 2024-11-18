FROM mskcc/roslin-variant-vcf2maf:1.6.17
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/vcf2maf:1.6.17/Dockerfile

LABEL maintainer="Christopher Allan Bolipata (bolipatc@mskcc.org)" \
      contributor="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.vcf2maf="1.6.17" \
      version.vep="86" \
      version.htslib="1.9" \
      version.bcftools="1.9" \
      version.samtools="1.9" \
      version.perl="5.26.2-r1" \
      version.alpine="3.8" \
      source.vcf2maf="https://github.com/mskcc/vcf2maf/releases/tag/v1.6.17" \
      source.vep="http://dec2016.archive.ensembl.org/info/docs/tools/vep/script/vep_download.html#versions" \
      source.vep_cache="ftp.ensembl.org/ensembl/pub/release-86/variation/VEP/homo_sapiens_vep_86_GRCh37.tar.gz" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.9" \
      source.bcftools="https://github.com/samtools/bcftools/releases/tag/1.9" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.9"

ENV VCF2MAF_VERSION 1.6.17
ENV VEP_VERSION 86
ENV VEP_DATA /var/cache
ENV VEP_PATH /usr/bin/vep
ENV HTSLIB_VERSION 1.9
ENV SAMTOOLS_VERSION 1.9
ENV BCFTOOLS_VERSION 1.9

RUN apk add --update && apk add bash
