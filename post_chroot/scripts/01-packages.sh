#!/bin/bash

set -e

echo "Installing packages"
PACKAGES="./files/01-packages/packages.txt"
if [ ! -f "$PACKAGES" ]; then
    echo "packages.txt not found."
    echo "Exiting..."
    exit 1
fi
mapfile -t packages < "$PACKAGES"
# echo "${packages[@]}"

pacman -Syu --noconfirm
pacman -Fy
pacman -S --noconfirm --needed "${packages[@]}"
