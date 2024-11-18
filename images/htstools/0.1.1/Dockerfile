FROM mskcc/roslin-varinat-htstools:0.1.1
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/htstools/0.1.1/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.htstools="0.1.1" \
      version.htslib="1.5" \
      version.alpine="3.8" \
      source.htstools="https://github.com/mskcc/htstools/releases/tag/snp_pileup_0.1.1" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.5"

ENV HTSTOOLS_VERSION 0.1.1
ENV HTSLIB_VERSION 1.5

RUN apk add --update && apk add bash

ENV PYTHONNOUSERSITE set