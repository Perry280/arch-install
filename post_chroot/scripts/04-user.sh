#!/bin/bash

set -eu

ARCH_USER="arch"
if [ -n "$1" ]; then
    ARCH_USER="$1"
fi

WHEEL="%wheel\tALL=(ALL)\tALL"
sed -i "s/# $WHEEL/$WHEEL/" /etc/sudoers

useradd -mG wheel -s /bin/bash "$ARCH_USER"

USER_PW=""
while [ -n "$USER_PW" ]; do
    echo -n "Insert $ARCH_USER password: "
    read -rs USER_PW
    echo -n "Insert password again: "
    read -rs TMP
    if [[ -z "$USER_PW" || -z "$TMP" ]]; then
        echo "Type a password"
        USER_PW=""
    elif [ "$USER_PW" != "$TMP" ]; then
        echo "Password do not match"
        USER_PW=""
    fi
done
echo "$ARCH_USER:USER_PW" | chpasswd

chown "$ARCH_USER":"$ARCH_USER" "./user_files/*"
cp -fp "./user_files/*" "/home/$ARCH_USER/"
