FROM biocontainers/biocontainers:latest

LABEL maintainer="Nikhil Kumar (kumarn1@mskcc.org)" \
      version.image="1.0.0" \
      version.disambiguate="1.0.0" \
      version.bamtools="2.4.1" \
      source.disambiguate="https://github.com/AstraZeneca-NGS/disambiguate/tree/v1.0.0" \
      source.bamtools="https://github.com/BioContainers/containers/blob/master/bamtools/2.4.0/Dockerfile"

ENV BAM_TOOLS_VERSION 2.4.0
ENV DISAMBIGUATE_VERSION 1.0.0

LABEL software="Disambiguate"
LABEL software.version="2016.11.10"

RUN conda install -c bioconda bamtools=2.4.0
RUN conda install -c bioconda ngs-disambiguate=2016.11.10