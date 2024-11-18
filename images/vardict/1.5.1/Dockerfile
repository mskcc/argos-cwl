FROM mskcc/vardict:1.5.1
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/vardict/1.5.1/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.vardict="1.5.1" \
      version.r="3.5.1" \
      version.perl="5.26.2-r1" \
      version.alpine="3.8" \
      source.vardict="https://github.com/AstraZeneca-NGS/VarDictJava/releases/tag/v1.5.1" \
      source.r="https://pkgs.alpinelinux.org/package/edge/community/x86/R" \
      source.perl="https://pkgs.alpinelinux.org/package/edge/main/aarch64/perl"

ENV VARDICT_VERSION 1.5.1

RUN apk add --update && apk add bash