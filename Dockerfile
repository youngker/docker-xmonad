FROM ubuntu:21.04
MAINTAINER YoungJoo Lee "youngker@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN cd /etc/apt && \
    sed -i 's/archive.ubuntu.com/ftp.daum.net/g' sources.list

RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf

RUN apt-get update && apt-get install -y \
    at-spi2-core \
    ca-certificates \
    compton \
    curl \
    dbus-x11 \
    feh \
    fontconfig \
    git \
    libghc-xmonad-dev \
    libghc-xmonad-contrib-dev \
    libharfbuzz-dev \
    locales \
    make \
    psmisc \
    rofi \
    stow \
    sudo \
    supervisor \
    tmux \
    tzdata \
    wget \
    xcape \
    xmobar \
    xmonad \
    xorg \
    xrdp \
    xorgxrdp \
 && rm -rf /var/lib/apt/lists/* /tmp/*

RUN echo "Asia/Seoul" > /etc/timezone && rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime && dpkg-reconfigure tzdata

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && dpkg-reconfigure locales

RUN git clone https://github.com/youngker/dotfiles.git /etc/skel/.dotfiles && \
    rm /etc/skel/.bashrc && rm /etc/fonts/conf.d/70-no-bitmaps.conf && \
    cp -rp /etc/skel/.dotfiles/fonts /usr/share/fonts/truetype/docker && \
    cd /etc/skel/.dotfiles && make && \
    fc-cache -fv

RUN git clone https://github.com/youngker/st.git /tmp/st && \
    cd /tmp/st && \
    make install && \
    rm -rf /tmp/st

COPY etc/ /etc/

RUN useradd -s /bin/bash -m docker && \
    echo "docker:docker" | chpasswd && \
    echo "docker ALL=(ALL) ALL" > /etc/sudoers.d/docker && \
    chmod 0440 /etc/sudoers.d/docker

RUN chown -R docker:docker /home/docker

RUN echo 'allowed_users = anybody' > /etc/X11/Xwrapper.config
RUN printf 'sleep 1\n/etc/skel/.dotfiles/scripts/bin/init-keyboard' >> /etc/xrdp/reconnectwm.sh
RUN mkdir -p /var/run/dbus && chown messagebus:messagebus /var/run/dbus && dbus-uuidgen --ensure
RUN sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
