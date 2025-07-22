#!/bin/bash

set -eu

bash "./01-general_settings.sh"
bash "./02-partition.sh"

pacstrap -K /mnt base linux linux-headers

genfstab -U /mnt >> /mnt/etc/fstab
