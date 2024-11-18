FROM ubuntu:16.04

# Create this directory in the container, which is the same as what's on our local cluster's implementation
RUN mkdir -p /opt/common/CentOS_6-dev/picard/v2.13/

RUN apt-get update -y && apt-get install -y \
    zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev \
    libnss-sss \
    curl \
    less \
    vim  \
    wget \
    unzip \
    build-essential \
    bzip2 \
    libcurl4-openssl-dev \
    cpanminus \
    openjdk-8-jdk \
    git

# Install a very specific version of picard
RUN apt-get update -y && apt-get install -y \
   && cd /tmp && wget https://github.com/broadinstitute/picard/releases/download/2.13/picard.jar \
   && mv /tmp/picard.jar /opt/common/CentOS_6-dev/picard/v2.13

# Install java and samtools, specifically needed by unpack_bam.pl
RUN cd /tmp \
    && wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 \
    && tar vxjf samtools-1.9.tar.bz2 \
    && cd samtools-1.9 \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && rm -rf /tmp/*

# Copy unpack_bam.pl, one of the scripts in mskcc/cmo-scripts repo
# In the future, add all the other perl scripts
COPY unpack_bam.pl /opt/

RUN cpanm Pod::Usage && cpanm JSON::Parse