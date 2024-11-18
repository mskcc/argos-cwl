FROM mskcc/roslin-variant-htslib:1.9
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/htslib/1.9/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.bcftools="1.9" \
      version.htslib="1.9" \
      version.samtools="1.9" \
      version.alpine="3.8" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.9" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.9" \
      source.bcftools="https://github.com/samtools/bcftools/releases/tag/1.9"

ENV BCFTOOLS_VERSION 1.9
ENV HTSLIB_VERSION 1.9
ENV SAMTOOLS_VERSION 1.9

RUN apk add --update && apk add bash