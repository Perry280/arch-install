#!/bin/bash

set -eu

bootctl --esp-path=/efi install
FILES="./files/06-bootloader"
cp -rf "$FILES/efi" "/efi"
rm -f /boot/initramfs*

LINUX_PRESET="/etc/mkinitcpio.d/linux.preset"
sed -i "s/^\(.*\)_image/#\1_image/" "$LINUX_PRESET"
sed -i "s/^#\(.*\)_uki/\1_uki/" "$LINUX_PRESET"

REPLACE='s/^fallback_options="\(.*\)"$/fallback_options="--cmdline \/etc\/kernel\/fallback_cmdline \1"/'
sed -i "$REPLACE" "$LINUX_PRESET"

CMDLINE="/etc/kernel"
touch "$CMDLINE/cmdline"

DISK=""
if [ -b "/dev/nvme0n1p3" ]; then
    DISK="/dev/nvme0n1p3"
else
    DISK="/dev/sda3"
fi

UUID=$(blkid -o export "$DISK" | grep "^UUID=")
echo "root=$UUID rw" | tee "$CMDLINE/cmdline"
cp "$CMDLINE/cmdline" "$CMDLINE/fallback_cmdline"

mkinitcpio -P
