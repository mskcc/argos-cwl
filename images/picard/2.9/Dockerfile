FROM mskcc/roslin-variant-picard:2.9
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/picard/2.9/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.picard="2.9" \
      version.alpine="3.8" \
      version.r="3.5.1" \
      source.picard="https://github.com/broadinstitute/picard/releases/tag/2.9.0" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R"

ENV TOOL_VERSION 2.9.0

RUN apk add --update && apk add bash
