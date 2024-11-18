FROM mskcc/roslin-variant-abra:2.17
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/abra/2.17/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.abra="2.17" \
      version.alpine="3.8" \
      version.java="8" \
      source.abra="https://github.com/mozack/abra2/releases/tag/v2.17"

ENV ABRA_VERSION 2.17

RUN apk add --update && apk add bash