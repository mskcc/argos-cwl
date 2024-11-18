FROM mskcc/roslin-variant-ngs-filters:1.4
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/ngs-filters/1.4/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.ngsfilters="1.4" \
      version.r="3.5.1" \
      version.alpine="3.8" \
      source.ngsfilters="https://github.com/mskcc/ngs-filters/releases/tag/v1.4" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV NGS_FILTERS_VERSION 1.4

RUN apk add --update && apk add bash

# disable per-user site-packages
ENV PYTHONNOUSERSITE set
