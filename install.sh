#!/bin/bash

set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "This script must be run as root. Try using sudo."
    exit 1
fi

find ./ -type f ! -exec grep -q '^#!/bin/bash' {} \; -exec chmod 644 {} \;
find ./ -type f -exec grep -q '^#!/bin/bash' {} \; -exec chmod 755 {} \;

echo "Checking Linux distribution."
if [[ ! -d "/etc" || ! -f "/etc/os-release" ]]; then
    echo 'File "/etc/os-release" not found. Cannot determine Linux distribution.'
    echo 'Exiting...'
    exit 1
fi

ID=$(grep "^ID=" /etc/os-release | cut -d= -f2)
if [ "$ID" != "arch" ]; then
    echo "Not running on Arch Linux."
    echo 'Exiting...'
    exit 1
fi

echo "Running on Arch Linux."

LIVE_ENVIRONMENT="live_environment"
if [[ -d "./$LIVE_ENVIRONMENT" && -f "./$LIVE_ENVIRONMENT/$LIVE_ENVIRONMENT.sh" ]]; then
    (
        cd "./$LIVE_ENVIRONMENT" || exit 1
        bash "./$LIVE_ENVIRONMENT.sh"
    )
fi

echo "Copying files for post arch-chroot install in /root directory."
cp -rf "./post_chroot" "/mnt/root/"
echo "Run:"
echo "# arch-chroot /mnt"
echo "# cd /root/post_chroot/"
echo "# ./postinstall.sh"
