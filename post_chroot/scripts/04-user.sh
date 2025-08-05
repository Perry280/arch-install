#!/bin/bash

set -eu

ARCH_USER="arch"
if [ -n "$1" ]; then
    ARCH_USER="$1"
fi

echo "Allow wheel group to use sudo"
WHEEL="%wheel ALL=(ALL:ALL) ALL"
sed -i "s/# $WHEEL/$WHEEL/" /etc/sudoers

echo "Creating user $ARCH_USER"
useradd -mG wheel -s /bin/bash "$ARCH_USER"

# USER_PW=""
# while [ -z "$USER_PW" ]; do
#     echo -n "Insert $ARCH_USER password: "
#     read -rs USER_PW
#     echo ""
#     echo -n "Insert password again: "
#     read -rs TMP
#     echo ""
#     if [[ -z "$USER_PW" || -z "$TMP" ]]; then
#         echo "Type a password"
#         USER_PW=""
#     elif [ "$USER_PW" != "$TMP" ]; then
#         echo "Password do not match"
#         USER_PW=""
#     fi
# done
# echo "$ARCH_USER:USER_PW" | chpasswd

echo "Password for $ARCH_USER."
passwd "$ARCH_USER"
while [ "$?" -ne 0 ]; do
    passwd "$ARCH_USER"
done

echo "Copying user files"
FILES="./files/04-user"
if [ -n "$(ls "$FILES")" ]; then
    for f in "$FILES"/* ; do
        chown "$ARCH_USER":"$ARCH_USER" "$f"
        cp -fp "$f" "/home/$ARCH_USER/"
    done
fi

if [ -n "$(ls -A "$FILES" | grep "^\.*")" ]; then
    for f in "$FILES"/.* ; do
        chown "$ARCH_USER":"$ARCH_USER" "$f"
        cp -fp "$f" "/home/$ARCH_USER/"
    done
fi

(
    cd "/home/$ARCH_USER"
    USER_DIR=("Desktop" "Desktop/share" ".config" ".local" ".local/share" "repos")
    for d in "${USER_DIR[@]}" ; do
        mkdir -p "$d"
        chown "$ARCH_USER":"$ARCH_USER" "$d"
    done
)
