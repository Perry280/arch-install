#!/bin/bash

set -eu

bash "./01-general_settings.sh"
bash "./02-partition.sh"

echo "Installing base system"
pacstrap -K /mnt base linux linux-headers

echo "Genereting fstab"
genfstab -U /mnt >> /mnt/etc/fstab
