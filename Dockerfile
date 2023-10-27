ARG BASE_IMAGE="ubuntu"
ARG TAG="22.04"
FROM ${BASE_IMAGE}:${TAG}
WORKDIR /vesc

ARG DEBIAN_FRONTEND=noninteractive
ARG USER_NAME=vesc
ARG USER_UID=1000
ARG USER_GID=1000
ARG ARM_SDK_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2

RUN groupadd ${USER_NAME} --gid ${USER_GID}\
    && useradd -l -m ${USER_NAME} -u ${USER_UID} -g ${USER_GID} -s /bin/bash

RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo \
    bash-completion \
    python3 python-is-python3 git\
    wget curl iputils-ping \
    make ca-certificates xz-utils bzip2

ENV USER=${USER_NAME}

RUN echo "vesc ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME}
RUN chmod 0440 /etc/sudoers.d/${USER_NAME}

RUN chown -R ${USER_NAME}:${USER_NAME} /${USER_NAME}

USER ${USER_NAME}

RUN  sudo mkdir /opt/gcc-arm-none-eabi \
         && sudo wget --no-check-certificate -N -P /opt/ "${ARM_SDK_URL}" \
         && cd /opt/ \
         && sudo tar -xjf gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 -C /opt/gcc-arm-none-eabi --strip-components=1
ENV PATH="${PATH}:/opt/gcc-arm-none-eabi/bin"
RUN sudo rm -rf /opt/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2        

CMD ["bash"]
