FROM cimg/openjdk:11.0.21-node as base_image

LABEL maintainer="Jeremiah Zucker <zucker.jeremiah@gmail.com>"

ENV BAZELISK_VERSION 1.20.0
RUN wget -q https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 -O bazelisk && \
    chmod +x bazelisk && \
    sudo mkdir /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo mv bazelisk /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo ln -s /opt/bazelisk-v${BAZELISK_VERSION}/bazelisk /usr/local/bin/bazel

ENV SDK_TOOLS_VERSION=7302050 \
    ANDROID_HOME=/opt/android \
    CMD_LINE_TOOLS=/opt/android/cmdline-tools

RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O commandlinetools.zip \
    && sudo mkdir -p ${CMD_LINE_TOOLS} \
    && sudo unzip -q commandlinetools.zip -d /tmp/ \
    && sudo mv /tmp/cmdline-tools/ ${CMD_LINE_TOOLS}/latest \
    && rm commandlinetools.zip

ADD license_accepter.sh ${ANDROID_HOME}
RUN sudo chmod +x ${ANDROID_HOME}/license_accepter.sh && \
    sudo ${ANDROID_HOME}/license_accepter.sh ${ANDROID_HOME}

RUN yes | sudo ${CMD_LINE_TOOLS}/bin/sdkmanager --licenses || if [ $? -ne '141' ]; then exit $?; fi;
RUN yes | sudo ${CMD_LINE_TOOLS}/bin/sdkmanager --update || if [ $? -ne '141' ]; then exit $?; fi;

ENV ANDROID_VERSION=33 \
    ANDROID_BUILD_TOOLS_VERSION=33.0.1 \
    ANDROID_NDK_VERSION=21.4.7075529

RUN sudo /opt/android/cmdline-tools/latest/bin/sdkmanager "build-tools;33.0.1" \
    "platforms;android-33" \
    "platform-tools"

RUN wget -q https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip -O ndk.zip \
    && sudo mkdir -p ${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION} \
    && sudo unzip -q ndk.zip -d /tmpNdk/ \
    && sudo mv /tmpNdk/android-ndk-r21e/* ${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION} \
    && rm ndk.zip

ENV ANDROID_SDK_HOME=${ANDROID_HOME} \
    ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION} \
    PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_TOOLS}

RUN sudo ln -sf /usr/bin/python3 /usr/bin/python

ARG RUBY_VERSION=2.7.2

SHELL ["/bin/bash", "-l", "-c"]

# Install rbenv
RUN sudo apt-get update && sudo apt-get install rbenv -y && sudo rm -rf /var/lib/apt/lists/*
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
RUN echo 'eval "$(rbenv init -)"' > ~/.bashrc
RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION