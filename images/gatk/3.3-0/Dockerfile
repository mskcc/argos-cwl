FROM mskcc/roslin-variant-gatk:3.3-0
# Base Dockerfile: https://github.com/mskcc/roslin-variant/blob/2.6.x/build/containers/gatk/3.3-0/Dockerfile

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.gatk="3.3-0" \
      version.alpine="3.8" \
      version.java="8" \
      source.gatk="https://software.broadinstitute.org/gatk/download/auth?package=GATK-archive&version=3.3-0-g37228af"

ENV GATK_VERSION 3.3-0
ENV GATK_DOWNLOAD_URL https://s3.us-east-2.amazonaws.com/roslindata/gatk-3.3-0.jar

RUN apk add --update && apk add bash