#!/bin/bash

set -eu

ARCH_USER="arch"
if [ -n "$1" ]; then
    ARCH_USER="$1"
fi

echo "Allow wheel group to use sudo"
WHEEL="%wheel\tALL=(ALL)\tALL"
sed -i "s/# $WHEEL/$WHEEL/" /etc/sudoers

echo "Creating user $ARCH_USER"
useradd -mG wheel -s /bin/bash "$ARCH_USER"

USER_PW=""
while [ -n "$USER_PW" ]; do
    echo -n "Insert $ARCH_USER password: "
    read -rs USER_PW
    echo ""
    echo -n "Insert password again: "
    read -rs TMP
    echo ""
    if [[ -z "$USER_PW" || -z "$TMP" ]]; then
        echo "Type a password"
        USER_PW=""
    elif [ "$USER_PW" != "$TMP" ]; then
        echo "Password do not match"
        USER_PW=""
    fi
done
echo "$ARCH_USER:USER_PW" | chpasswd

echo "Copying user files"
FILES="./files/04-user"
shopt -s nullglob dotglob
FILES=("$FILES/*")
if (( ${#FILES[@]} )); then
    for f in "$FILES" ; do
        chown "$ARCH_USER":"$ARCH_USER" "$f"
    done

    cp -fp "$FILES" "/home/$ARCH_USER/"
fi

(
    cd "/home/$ARCH_USER"
    mkdir -p "Desktop/share"
    chown -R "$ARCH_USER":"$ARCH_USER" "Desktop"
)
