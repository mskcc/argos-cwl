FROM mskcc/roslin-variant-conpair:0.3.3
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/conpair/0.3.3/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.conpair="0.3.3" \
      version.alpine="3.10" \
      version.gatk="3.3-0" \
      source.gatk="https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.3-0-g37228af" \
      source.conpair="https://github.com/mskcc/Conpair/releases/tag/0.3.1" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV CONPAIR_VERSION 0.3.3
ENV GATK_VERSION 3.3-0
ENV GATK_DOWNLOAD_URL https://s3.us-east-2.amazonaws.com/roslindata/gatk-3.3-0.jar

RUN apk add --update && apk add bash

ENV LANG "C.UTF-8"
ENV PYTHONNOUSERSITE set
