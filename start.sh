#!/bin/bash

dbus-daemon --system

/bin/sh /usr/share/xrdp/socksetup

xrdp-sesman -ns &
xrdp -ns
