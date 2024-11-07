#!/bin/bash

# Get the default sink name (audio output device)
DEFAULT_SINK=$(pactl get-default-sink)

# Retrieve the current mute state of the default sink
MUTE_STATE=$(pactl get-sink-mute $DEFAULT_SINK | awk '{print $2}')

# Check the mute state and toggle it
if [ "$MUTE_STATE" = "yes" ]; then
    pactl set-sink-mute $DEFAULT_SINK 0
    notify-send "Volume changed" "unmuted"
else
    pactl set-sink-mute $DEFAULT_SINK 1
	notify-send "Volume changed" "Muted"	
fi

