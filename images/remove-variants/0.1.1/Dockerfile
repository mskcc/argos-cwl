FROM mskcc/roslin-variant-remove-variants:0.1.1
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/remove-variants/0.1.1/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.removevariants="0.1.1" \
      version.alpine="3.8" \
      source.removevariants="https://github.com/mskcc/remove_variants/releases/tag/0.1.1"

ENV REMOVEVARIANTS_VERSION 0.1.1

RUN apk add --update && apk add bash

# disable per-user site-packages before run
ENV PYTHONNOUSERSITE set