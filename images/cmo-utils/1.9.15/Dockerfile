FROM mskcc/roslin-variant-cmo-utils:1.9.15
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/cmo-utils/1.9.15/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.getBaseCountsMultiSample="1.2.2" \
      version.samtools="1.9" \
      version.htslib="1.9" \
      version.alpine="3.8" \
      version.picard="2.9" \
      version.cmo="1.9.15" \
      version.r="3.5.1" \
      source.picard="https://github.com/broadinstitute/picard/releases/tag/2.9.0" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.htslib="https://github.com/samtools/htslib/releases/tag/1.9" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.9" \
      source.getBaseCountsMultiSample="https://github.com/zengzheng123/GetBaseCountsMultiSample/releases/tag/v1.2.2" \
      source.cmo="https://github.com/mskcc/cmo/releases/tag/1.9.15"


ENV GET_BASE_COUNTS_MULTI_SAMPLE_VERSION 1.2.2
ENV CMO_VERSION 1.9.15
ENV HTSLIB_VERSION 1.9
ENV SAMTOOLS_VERSION 1.9
ENV PICARD_VERSION 2.9.0

RUN apk add --update && apk add bash

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set