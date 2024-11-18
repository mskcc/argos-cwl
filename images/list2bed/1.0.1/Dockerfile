FROM mskcc/roslin-variant-list2bed:1.0.1
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/list2bed/1.0.1/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.list2bed="1.0.1" \
      version.alpine="3.8" \
      source.list2bed="https://github.com/mskcc/list2bed/releases/tag/1.0.1"

ENV LIST2BED_VERSION 1.0.1

RUN apk add --update && apk add bash

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set