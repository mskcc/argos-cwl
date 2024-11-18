FROM mskcc/roslin-variant-delly:0.7.7
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/delly/0.7.7/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.delly="0.7.7" \
      version.htslib="1.6" \
      version.bcftools="1.6" \
      version.samtools="1.6" \
      version.alpine="3.8" \
      source.delly="https://github.com/dellytools/delly/releases/tag/v0.7.7" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.6" \
      source.bcftools="https://github.com/samtools/bcftools/releases/tag/1.6" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.6"

ENV DELLY_VERSION v0.7.7
ENV HTSLIB_VERSION 1.6
ENV BCFTOOLS_VERSION 1.6
ENV SAMTOOLS_VERSION 1.6

# set environment
ENV BOOST_ROOT /usr
ENV SEQTK_ROOT /opt/htslib

RUN apk add --update && apk add bash