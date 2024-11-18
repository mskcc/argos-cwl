FROM mskcc/roslin-variant-facets:1.6.3
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/facets/1.6.3/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.facets_suite="1.6.3" \
      version.facets="0.5.14"\
      version.alpine="3.10" \
      version.r="3.6" \
      version.pctGCdata="0.2.0" \
      source.facets_suite="https://github.com/mskcc/facets-suite/releases/tag/1.6.3" \
      source.facets="https://github.com/mskcc/facets/archive/v0.5.14.tar.gz"\
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV FACETS_SUITE_VERSION 1.6.3
ENV FACETS_VERSION 0.5.14
ENV PCTGCDATA 0.2.0

RUN apk add --update && apk add bash

ENV LANG "C.UTF-8"
ENV PYTHONNOUSERSITE set
ENV FACETS_OVERRIDE_EXITCODE set
