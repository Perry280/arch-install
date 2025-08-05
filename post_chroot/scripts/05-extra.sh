#!/bin/bash

set -eu

ARCH_USER="arch"
if [ -n "$1" ]; then
    ARCH_USER="$1"
fi

echo "Installing neovim"
(
    cd "/home/$ARCH_USER/.config"
runuser -u "$ARCH_USER" -- bash << 'EOF'
git clone https://github.com/Perry280/coding-setups.git
mv coding-setups/neovim/nvim .
rm -rf coding-setups
chmod 755 nvim
find ./nvim -type d -exec chmod 755 {} \;
find ./nvim -type f -exec chmod 644 {} \;
EOF
    cd "/home/$ARCH_USER/.config"
    cp -rf ./nvim /root/.config
)

echo "Installing lua-language-server"
(
    cd "/home/$ARCH_USER/.local/share"
runuser -u "$ARCH_USER" -- bash << 'EOF'
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
cd ..
EOF
    LUA="/home/$ARCH_USER/.local/share/lua-language-server/bin/lua-language-server"
    LUA_LINK="/usr/local/bin/lua-language-server"
    ln -sf "$LUA" "$LUA_LINK"
)

echo "Installing yay"
(
    cd "/home/$ARCH_USER/repos"
runuser -u "$ARCH_USER" -- bash << 'EOF'
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
yay -Y --gendb
yay -Y --devel --save
yay
EOF
)
