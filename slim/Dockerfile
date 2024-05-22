FROM cimg/node:18.20 as base_image

LABEL maintainer="Ketan Reddy <ketan@ketanreddy.com>"

ENV BAZELISK_VERSION 1.20.0

SHELL ["/bin/bash", "-l", "-c"]

RUN wget -q https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 -O bazelisk && \
    chmod +x bazelisk && \
    sudo mkdir /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo mv bazelisk /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo ln -s /opt/bazelisk-v${BAZELISK_VERSION}/bazelisk /usr/local/bin/bazel