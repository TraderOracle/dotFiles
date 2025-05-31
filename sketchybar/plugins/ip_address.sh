#!/usr/bin/env bash

IP_INTERNAL=$(ipconfig getifaddr en1)
IP_EXTERNAL=$(curl ifconfig.me)
COLOR=$BLUE
ICON=
LABEL=$IP_ADDRESS

sketchybar -m --set $NAME label="$IP_INTERNAL   🌏 $IP_EXTERNAL"
