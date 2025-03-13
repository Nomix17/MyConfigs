#!/bin/bash

picname=~/Pictures/Screenshots/Screenshot_from_$(date +"%Y-%m-%d__%H:%M:%S").png

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    if [ ! -d ~/Pictures/Screenshots ]; then
        mkdir -p ~/Pictures/Screenshots
    fi
    scrot "$picname"
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    mkdir -p ~/Pictures/Screenshots
    grim "$picname"
fi

