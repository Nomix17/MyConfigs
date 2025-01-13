#!/bin/bash

# Get the current brightness value
BRIGHTNESS_VALUE=$(brightnessctl | grep -o "(.*" | tr -d "()")
BRIGHTNESS_NR=${BRIGHTNESS_VALUE//%}

# Define colors
ICON_COLOR='#1F6563'  # Color for the icon
TEXT_COLOR='#C5C8C6'  # Color for the text

# Set the icon based on brightness level
if [ $BRIGHTNESS_NR -lt 20 ]; then
    BRIGHTNESS_ICON=" "  # Low brightness icon
else
    BRIGHTNESS_ICON=" "  # Normal brightness icon
fi

# Output the icon and brightness value with colors
echo "%{F$ICON_COLOR}$BRIGHTNESS_ICON%{F$TEXT_COLOR} $BRIGHTNESS_VALUE%{F-}"

