#!/bin/bash

dbus-daemon --system

xrdp-sesman -ns &
xrdp -ns
