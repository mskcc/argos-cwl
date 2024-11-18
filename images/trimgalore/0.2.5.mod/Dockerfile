FROM mskcc/roslin-variant-trimgalore:0.2.5.mod
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/trimgalore/0.2.5.mod/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.trimgalore="0.2.5.mod" \
      version.cutadapt="1.1" \
      version.alpine="3.8" \
      source.trimgalore="http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/" \
      source.cutadapt="https://github.com/marcelm/cutadapt/releases/tag/v1.1"

ENV TRIM_GALORE_VERSION 0.2.5.mod
ENV CUTADAPT_VERSION 1.1

RUN apk add --update && apk add bash