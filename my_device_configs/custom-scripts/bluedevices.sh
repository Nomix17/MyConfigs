#!/bin/bash

# Check for connected Bluetooth devices
connected_device=$(bluetoothctl devices Connected | awk '{print $3, $4, $5, $6, $7}' | sed 's/ $//')

if [ -n "$connected_device" ]; then
    echo "$connected_device"
fi

