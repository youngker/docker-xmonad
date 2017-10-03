FROM ubuntu:17.10
MAINTAINER YoungJoo Lee "youngker@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf

RUN apt-get update && apt-get install -y \
    ca-certificates \
    compton \
    curl \
    dbus-x11 \
    feh \
    fontconfig \
    fonts-firacode \
    git \
    konsole \
    locales \
    psmisc \
    rofi \
    stow \
    sudo \
    supervisor \
    tzdata \
    wget \
    xcape \
    xmobar \
    xmonad \
    xorg \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    build-essential \
    file \
    libpam0g-dev \
    libssl-dev \
    libxfixes-dev \
    libxfont1-dev \
    libxrandr-dev \
    nasm \
    pkg-config \
    xserver-xorg-dev \
 && cd /tmp && \
    wget --no-check-certificate https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/xrdp-0.9.3.1.tar.gz && \
    tar xvzf xrdp-0.9.3.1.tar.gz && \
    cd xrdp-0.9.3.1 && ./configure && make && make install \
 && cd /tmp && \
    wget --no-check-certificate https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/xorgxrdp-0.2.3.tar.gz && \
    tar xvzf xorgxrdp-0.2.3.tar.gz && \
    cd xorgxrdp-0.2.3 && ./configure && make && make install \
 && apt-get remove -y \
    build-essential \
    file \
    libpam0g-dev \
    libssl-dev \
    libxfixes-dev \
    libxfont1-dev \
    libxrandr-dev \
    nasm \
    pkg-config \
    xserver-xorg-dev \
 && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/* /tmp/*

RUN git clone https://github.com/youngker/dotfiles.git /etc/skel/.dotfiles && \
    git clone https://github.com/youngker/xmonadic-zest.git /etc/skel/.xmonad && \
    rm /etc/skel/.bashrc && rm /etc/fonts/conf.d/70-no-bitmaps.conf

COPY etc/ /etc/
ADD images/wallpaper1.jpg /usr/share/backgrounds/wallpaper1.jpg
ADD images/wallpaper2.jpg /usr/share/backgrounds/wallpaper2.jpg

RUN useradd -s /bin/bash -m docker && \
    echo "docker:docker" | chpasswd && \
    echo "docker ALL=(ALL) ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

run chown -R docker:docker /home/docker

RUN echo 'allowed_users = anybody' > /etc/X11/Xwrapper.config
RUN printf 'sleep 1\n/etc/skel/.dotfiles/scripts/bin/init-keyboard' >> /etc/xrdp/reconnectwm.sh
RUN mkdir -p /var/run/dbus && chown messagebus:messagebus /var/run/dbus && dbus-uuidgen --ensure
RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
