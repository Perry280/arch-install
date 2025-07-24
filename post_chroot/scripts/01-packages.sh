#!/bin/bash

set -e

PACKAGES="./files/01-packages/packages.txt"
if [ ! -f "$PACKAGES" ]; then
    echo "packages.txt not found."
    echo "Exiting..."
    exit 1
fi
mapfile -t packages < "$PACKAGES"
# echo "${packages[@]}"

pacman -Syu --noconfirm
pacman -S --noconfirm --needed "${packages[@]}"
