FROM mskcc/roslin-variant-samtools:1.3.1
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/samtools/1.3.1/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.samtools="1.3.1" \
      version.alpine="3.8" \
      source.samtools="https://github.com/samtools/samtools/releases/tag/1.3.1"

ENV TOOL_VERSION 1.3.1

RUN apk add --update && apk add bash