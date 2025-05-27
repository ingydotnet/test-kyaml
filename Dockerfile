FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TMP=/tmp/kyaml-test-server

RUN apt update \
 && apt install -y \
        curl \
        git \
        golang \
        make \
        vim \
        xz-utils \
 && curl -s https://yamlscript.org/install | \
    BIN=1 bash \
 && true

RUN git config --global --add safe.directory /work
RUN mkdir /tmp/kyaml-test-server
