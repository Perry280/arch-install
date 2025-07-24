#!/bin/bash

set -eu

LAYOUT="it"
FONT="eurlatgr"
TIMEZONE="Europe/Rome"

echo "Set keyboard layout to: $LAYOUT"
loadkeys "$LAYOUT"

echo "Set font to: $FONT"
setfont "$FONT"

echo "Set timezone to: $TIMEZONE"
timedatectl set-timezone "$TIMEZONE"
timedatectl set-ntp true
hwclock --systohc
# timedatectl
