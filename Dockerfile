FROM ubuntu:trusty

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    ca-certificates \
    curl \
    git \
    libcurl3-dev \
    libffi-dev \
    libfontconfig \
    libgdbm-dev \
    libgdbm3 \
    libjemalloc-dev \
    libncurses5-dev \
    libreadline6-dev \
    libssl-dev \
    libyaml-dev \
    zlib1g-dev

COPY . .

ENTRYPOINT bash
