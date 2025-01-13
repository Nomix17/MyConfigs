picname="Screenshot_from_%Y-%m-%d__%H:%M:%S.png"
scrot -b "$picname" -e 'mv $f ~/Pictures/Screenshots'
notify-send -t 1000 "Screenshot has been saved"
