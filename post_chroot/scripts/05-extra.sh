#!/bin/bash

set -eu

ARCH_USER="arch"
if [ -n "$1" ]; then
    ARCH_USER="$1"
fi

echo "Installing neovim"
(
    cd "/home/$ARCH_USER/.config"
    git clone https://github.com/Perry280/coding-setups.git
    mv coding-setups/neovim/nvim .
    rm -rf coding-setups
    chmod 755 nvim
    find ./nvim -type d -exec chmod 755 {} \;
    find ./nvim -type f -exec chmod 644 {} \;
    cp -rf nvim /root/.config
    chown -R "$ARCH_USER":"$ARCH_USER" nvim
)

echo "Installing lua-language-server"
(
    cd "/home/$ARCH_USER/.local/share"
    git clone https://github.com/LuaLS/lua-language-server
    cd lua-language-server
    ./make.sh
    cd ..
    chown -R "$ARCH_USER":"$ARCH_USER" lua-language-server
    LUA="/home/$ARCH_USER/.local/share/lua-language-server/bin/lua-language-server"
    LUA_LINK="/usr/local/bin/lua-language-server"
    ln -sf "$LUA" "$LUA_LINK"
)

echo "Installing yay"
(
    cd "/home/$ARCH_USER/repos"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    yay -Y --gendb
    yay -Y --devel --save
    yay
    cd "/home/$ARCH_USER"
    chown -R "$ARCH_USER":"$ARCH_USER" repos
)
