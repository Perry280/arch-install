#!/bin/bash

set -eu

pacman -S --noconfirm --needed virtualbox-guest-utils
rcvboxadd reload
VBoxClient-all
