FROM mskcc/roslin-variant-basic-filtering:0.3
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/basic-filtering/0.3/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.basicfiltering="0.3" \
      version.alpine="3.8" \
      version.cmo="1.9.15" \
      version.bcftools="1.9" \
      source.cmo="https://github.com/mskcc/cmo/releases/tag/1.9.15" \
      source.basicfiltering="https://github.com/mskcc/basicfiltering/releases/tag/0.3" \
      source.bcftools="https://github.com/samtools/bcftools/releases/tag/1.9"

ENV BASICFILTERING_VERSION 0.3
ENV HTSLIB_VERSION 1.5
ENV CMO_VERSION 1.9.15
ENV BCFTOOLS_VERSION 1.9

RUN apk add --update && apk add bash

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set