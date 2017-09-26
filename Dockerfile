from ubuntu:latest
maintainer YoungJoo Lee

env XRDP_PKG xrdp-0.9.3.1
env XORG_PKG xorgxrdp-0.2.3

arg DEBIAN_FRONTEND=noninteractive

run apt-get update

run apt-get install -y dbus-x11 dmenu feh git gmrun software-properties-common sudo wget xmobar xmonad xorg rxvt-unicode && apt-get clean

run apt-get install -y emacs supervisor && apt-get clean && sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

run apt-get install -y libssl-dev libpam0g-dev nasm xserver-xorg-dev libxfont1-dev libxfixes-dev && apt-get clean

run cd / && \
    wget https://github.com/neutrinolabs/xrdp/releases/download/v0.9.3.1/$XRDP_PKG.tar.gz && \
    tar xvzf $XRDP_PKG.tar.gz && \
    cd $XRDP_PKG && ./configure && make && make install && cd / && \
    rm -f $XRDP_PKG.tar.gz && rm -rf $XRDP_PKG

run cd / && \
    wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v0.2.3/$XORG_PKG.tar.gz && \
    tar xvzf $XORG_PKG.tar.gz && \
    cd $XORG_PKG && ./configure && make && make install && cd / && \
    rm -f $XORG_PKG.tar.gz && rm -rf $XORG_PKG

run useradd --create-home --shell /bin/bash docker && adduser docker sudo
run echo "docker:docker" | chpasswd

copy home/ /home/
run fc-cache -vf /home/docker/.fonts && chown -R docker:docker /home/docker

copy etc/ /etc/
cmd ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
