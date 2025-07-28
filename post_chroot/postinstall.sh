#!/bin/bash

set -euo pipefail

ARCH_USER="arch"
ARCH_HOST="Arch"

ROOT_PW=""
while [ -n "$ROOT_PW" ]; do
    echo -n "Insert root password: "
    read -rs ROOT_PW
    echo -n "Insert password again: "
    read -rs TMP
    if [[ -z "$ROOT_PW" || -z "$TMP" ]]; then
        echo "Type a password"
        ROOT_PW=""
    elif [ "$ROOT_PW" != "$TMP" ]; then
        echo "Password do not match"
        ROOT_PW=""
    fi
done
echo "root:$ROOT_PW" | chpasswd

echo -n "Insert user name [Enter = arch]: "
read -r option
if [ -n "$option" ]; then
    ARCH_USER="$option"
fi
echo -n "Insert host name [Enter = Arch]: "
read -r option
if [ -n "$option" ]; then
    ARCH_HOST="$option"
fi

######################################################################
echo "Setting timezone"
TIMEZONE="Europe/Rome"
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

echo "Setting locales"
LOCALE_IT="it_IT.UTF-8 UTF-8"
LOCALE_US="en_US.UTF-8 UTF-8"

sed -i "s/#$LOCALE_IT/$LOCALE_IT/" /etc/locale.gen
sed -i "s/#$LOCALE_US/$LOCALE_US/" /etc/locale.gen
locale-gen

touch "./files/03-config_files/files/etc/hostname"
echo "$ARCH_HOST" | tee "./files/03-config_files/files/etc/hostname"

# Install packages
bash ./scripts/01-packages.sh

# VirtualBox Guest Additions
bash ./scripts/02-virtualbox.sh

# Copy configuration files
bash ./scripts/03-config_files.sh

# Copy user files
bash ./scripts/04-user.sh "$ARCH_USER"

# Neovim setup, lua-language-server, yay
bash ./scripts/05-extra.sh "$ARCH_USER"

# Bootloader
bash ./scripts/06-bootloader.sh
#
# Services and timers
bash ./scripts/07-services.sh

echo "Installation complete."
echo "Run:"
echo "exit"
echo "reboot"
