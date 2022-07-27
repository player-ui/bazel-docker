FROM cimg/openjdk:8.0-node as base_image

LABEL maintainer="Jeremiah Zucker <zucker.jeremiah@gmail.com>"

ENV BAZELISK_VERSION 1.11.0
RUN wget -q https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64 -O bazelisk && \
    chmod +x bazelisk && \
    sudo mkdir /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo mv bazelisk /opt/bazelisk-v${BAZELISK_VERSION} && \
    sudo ln -s /opt/bazelisk-v${BAZELISK_VERSION}/bazelisk /usr/local/bin/bazel

ENV ANDROID_SDK_VERSION=4333796 \
    ANDROID_HOME=/opt/android

RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip -O sdk.zip && \
    sudo mkdir ${ANDROID_HOME} && \
    sudo unzip sdk.zip -d ${ANDROID_HOME} && \
    rm sdk.zip

ADD license_accepter.sh ${ANDROID_HOME}
RUN sudo chmod +x ${ANDROID_HOME}/license_accepter.sh && \
    sudo ${ANDROID_HOME}/license_accepter.sh ${ANDROID_HOME}

ENV ANDROID_TOOLS=${ANDROID_HOME}/tools/bin

RUN yes | sudo ${ANDROID_TOOLS}/sdkmanager --licenses || if [ $? -ne '141' ]; then exit $?; fi; \
    yes | sudo ${ANDROID_TOOLS}/sdkmanager --update || if [ $? -ne '141' ]; then exit $?; fi;

ENV ANDROID_VERSION=29 \
    ANDROID_BUILD_TOOLS_VERSION=30.0.0 \
    ANDROID_NDK_VERSION=21.4.7075529

RUN sudo ${ANDROID_TOOLS}/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" \
    "ndk;${ANDROID_NDK_VERSION}"

ENV ANDROID_SDK_HOME=${ANDROID_HOME} \
    ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION} \
    PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_TOOLS}
