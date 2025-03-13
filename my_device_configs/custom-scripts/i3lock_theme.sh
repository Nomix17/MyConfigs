#!/bin/sh

BLANK='#00000000'
CLEAR='#00000000'
DEFAULT='#868a89'
TEXT='#868a89'
WRONG='#1e1e1e'
VERIFYING='#868a89'

i3lock \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--blur 10                     \
--clock                      \
--indicator                  \
--time-str="%I:%M:%S"        \
--date-str="%Y-%m-%d"       \

