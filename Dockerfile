FROM ubuntu:latest

run apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y dbus-x11 dmenu gmrun xmonad xorg rxvt-unicode vnc4server && apt-get clean

run apt-get install -y wget build-essential libssl-dev libpam0g-dev libxrandr-dev nasm xserver-xorg-dev libxfont1-dev pkg-config file libxfixes-dev && apt-get clean

run apt-get install -y autoconf automake build-essential curl git imagemagick ispell libdbus-1-dev libgif-dev libgnutls-dev libgtk2.0-dev libjpeg-dev libmagick++-dev libncurses-dev libpng-dev libtiff-dev libx11-dev libxpm-dev texinfo && apt-get clean

arg xrdp=https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/xrdp-0.9.3.1.tar.gz
run cd /tmp && wget $xrdp && tar -xf xrdp* -C /tmp/ && cd /tmp/xrdp* && ./configure && make && make install && rm -rf /tmp/xrdp*

arg xorgxrdp=https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/xorgxrdp-0.2.3.tar.gz
run cd /tmp && wget $xorgxrdp && tar -xf xorgxrdp* -C /tmp/ && cd /tmp/xorgxrdp* && ./configure && make && make install && rm -rf /tmp/xorgxrdp*

run apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:kelleyk/emacs \
    && apt-get update \
    && apt-get install -y emacs25
#arg emacs=http://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.gz
#run cd /tmp && wget $emacs && tar -xf emacs* -C /tmp/ && cd /tmp/emacs* && bash -c "echo 0 > /proc/sys/kernel/randomize_va_space" && ./autogen.sh && ./configure && make -j 8 install && rm -rf /tmp/emacs*

run apt-get install -y feh sudo

RUN useradd --create-home --shell /bin/bash docker && adduser docker sudo
RUN echo "docker:docker" | chpasswd

ADD Xdefaults /home/docker/.Xdefaults
ADD xsessionrc /home/docker/.xsessionrc
ADD wallhaven-501871.jpg /home/docker/Pictures/wallhaven-501871.jpg
ADD start.sh /start.sh

ENTRYPOINT /start.sh
