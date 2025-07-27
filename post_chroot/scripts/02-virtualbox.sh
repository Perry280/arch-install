#!/bin/bash

set -eu

echo "Installing virtualbox guest additions"
pacman -S --noconfirm --needed virtualbox-guest-utils
rcvboxadd reload
VBoxClient-all
