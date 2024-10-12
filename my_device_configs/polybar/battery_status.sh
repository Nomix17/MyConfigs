#!/bin/bash
state=$(acpi -b | grep -o 'Charging\|Discharging\|Full')
percent=$(acpi -b | grep -o '[0-9]*%')

# Remove the '%' character from the percent for comparisons
num_percent=${percent%\%}

if [[ $state == 'Charging' ]]; then
    # Select charging icon based on battery percentage
    if [ $num_percent -ge 80 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 60 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 40 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 20 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    else
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    fi
elif [[ $state == 'Full' ]]; then
    echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
elif [[ $state == 'Discharging' ]]; then
    # Select discharging icon based on battery percentage
    if [ $num_percent -ge 80 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 60 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 40 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    elif [ $num_percent -ge 20 ]; then
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    else
        echo "%{F#F0C674}  %{F#C5C8C6}$percent%{F-}"  # Icon in #F0C674, percentage in #C5C8C6
    fi
else
    echo "Battery state unknown"  # In case of unexpected state
fi

