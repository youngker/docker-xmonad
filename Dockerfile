FROM ubuntu:latest
MAINTAINER YoungJoo Lee "youngker@gmail.com"

ENV XRDP_PKG xrdp-0.9.3.1
ENV XORG_PKG xorgxrdp-0.2.3

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    dbus-x11 \
    git \
    locales \
    software-properties-common \
    sudo \
    supervisor \
    tzdata \
    wget \
    xmonad \
    xorg \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    libpam0g-dev \
    libssl-dev \
    libxfixes-dev \
    libxfont1-dev \
    nasm \
    xserver-xorg-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cd / && \
    wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/$XRDP_PKG.tar.gz && \
    tar xvzf $XRDP_PKG.tar.gz && \
    cd $XRDP_PKG && ./configure && make && make install && cd / && \
    rm -f $XRDP_PKG.tar.gz && rm -rf $XRDP_PKG

RUN cd / && \
    wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/$XORG_PKG.tar.gz && \
    tar xvzf $XORG_PKG.tar.gz && \
    cd $XORG_PKG && ./configure && make && make install && cd / && \
    rm -f $XORG_PKG.tar.gz && rm -rf $XORG_PKG

RUN apt-add-repository -y ppa:kelleyk/emacs

RUN apt-get update && apt-get install -y \
    dmenu \
    emacs25 \
    feh \
    gmrun \
    rxvt-unicode \
    xmobar \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -s /bin/bash -m docker && \
    echo "docker:docker" | chpasswd && \
    echo "docker ALL=(ALL) ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

COPY home/ /home/
COPY etc/ /etc/

run chown -R docker:docker /home/docker && fc-cache -f -v

run sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
cmd ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
