FROM mskcc/roslin-variant-roslin-qc:0.6.4
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/roslin-qc/0.6.4/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.roslin-qc="0.6.4" \
      version.getbasecountsmultisample="1.2.2" \
      version.bamtools="2.5.1" \
      version.alpine="3.10" \
      source.roslin-qc="https://github.com/mskcc/roslin-qc/releases/tag/0.6.4" \
      source.getbasecountsmultisample="https://github.com/zengzheng123/GetBaseCountsMultiSample" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.bamtools="https://github.com/pezmaster31/bamtools"

ENV ROSLIN_QC_VERSION 0.6.4
ENV GETBASECOUNTSMULTISAMPLE_VERSION 1.2.2
ENV BAMTOOLS_VERSION 2.5.1

ENV PATH "$PATH:/bin"

RUN apk add --update && apk add bash

ENV PYTHONNOUSERSITE set

ENV LANG "C.UTF-8"

ENTRYPOINT []
