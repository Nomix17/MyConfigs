#!/bin/bash

# Swap the config files
if [ -f ~/.config/picom/off.txt ] && [ -f ~/.config/picom/picom.conf ]; then
    mv ~/.config/picom/off.txt ~/picom.conf
    mv ~/.config/picom/picom.conf ~/off.txt
    mv ~/{off.txt,picom.conf} ~/.config/picom/
else
    echo "Error: One or both of the picom configuration files are missing."
    exit 1
fi

# Restart picom safely
killall picom
sleep 0.1
picom &

