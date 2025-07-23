#!/bin/bash

set -eu

FILES="./files/03-config_files"
if [ ! -d "$FILES" ]; then
    echo "03-config_files not found."
    echo "Exiting..."
    exit 1
fi

if [ ! -f "$FILES/pam_env.conf" ]; then
    echo "pam_env.conf not found."
    echo "Exiting..."
    exit 1
fi
cat "$FILES/pam_env.conf" | tee -a /etc/security/pam_env.conf

FILES="$FILES/files"
for d in "$FILES"/* ; do
    cp -rf "$d" "/$(basename "$d")"
done

JOURNAL="/etc/systemd/journald.conf"
sed -i "s/^#?Storage=*$/Storage=persistent/" "$JOURNAL"
sed -i "s/^#?SystemMaxUse=*$/SystemMaxUse=100M/" "$JOURNAL"
