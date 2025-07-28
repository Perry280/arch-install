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
echo "Setting pam_env env variable"
cat "$FILES/pam_env.conf" | tee -a /etc/security/pam_env.conf

echo "Copying configuration files"
FILES="$FILES/files"
(
    cd "$FILES"
    for d in ./* ; do
        cp -rf "$d" "/$d"
    done
)

echo "Setting journald"
JOURNAL="/etc/systemd/journald.conf"
sed -i "s/^#?Storage=.*$/Storage=persistent/" "$JOURNAL"
sed -i "s/^#?SystemMaxUse=.*$/SystemMaxUse=100M/" "$JOURNAL"

echo "Setting paccache"
PACCACHE_FLAGS="-k0"
sed -i "s/^PACCACHE=.*/PACCACHE='$PACCACHE_FLAGS'/" /etc/conf.d/pacman-contrib

sed -i "s/#Color/Color/" /etc/pacman.conf

echo "Setting makepkg.conf"
MAKEPKG="/etc/makepkg.conf"
sed -i  "s/^MAKEFLAGS=.*$/MAKEFLAGS=\"--jobs=\$(nproc)\"/" "$MAKEPKG"

CFLAGS="-march=native -O2 -pipe -fno-plt -fexceptions \
        -Wp,-D_FORTIFY_SOURCE=3 -Wformat -Werror=format-security \
        -fstack-clash-protection -fcf-protection \
        -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer \
        -ftree-vectorize -fvect-cost-model=cheap \
        -fno-semantic-interposition -msse -msse2 -msse3 -mmmx"
sed -i  "s/^CFLAGS=\"\(.*\\\n\)*.*\"$/CFLAGS=\"$CFLAGS\"/" "$MAKEPKG"

echo "Setting rust.conf"
RUSTFLAGS="-Cforce-frame-pointers=yes -C opt-level=2 -C target-cpu=native"
sed -i "s/^RUSTFLAGS=.*$/RUSTFLAGS=\"$RUSTFLAGS\"/" "/etc/makepkg.conf.d/rust.conf"
