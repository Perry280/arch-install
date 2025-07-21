#!/bin/bash

set -euo pipefail

######################################################################
######################################################################

run_script () {
    if [ -z "$1" ]; then
        echo "No argument passed"
        exit 1
    fi

    if [[ -d "./$1" && -f "./$1/script.sh" ]]; then
        (
            cd "./$1" || exit 1
            bash "./script.sh" "${@:2}"
        )
    fi
}

######################################################################
######################################################################

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
TIMEZONE="Europe/Rome"
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

LOCALE_IT="it_IT.UTF-8 UTF-8"
LOCALE_US="en_US.UTF-8 UTF-8"

sed -i "s/#$LOCALE_IT/$LOCALE_IT/" /etc/locale.gen
sed -i "s/#$LOCALE_US/$LOCALE_US/" /etc/locale.gen
locale-gen

echo "$ARCH_HOST" | tee "./$CONFIG_FILES/etc/hostname"

## Install packages
#run_script "$PACKAGES"

## VirtualBox Guest Additions
#run_script "$VIRTUALBOX"

## Copy configuration files
#run_script "$CONFIG_FILES"

## Copy user files
#run_script "$USER_FILES" "$ARCH_USER"

