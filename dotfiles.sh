#!/bin/bash

source utils.sh

installPackageManager
installOrUpdate "rcm"

cd "$HOME" || exit

echo ""
echo "Installing dot files..."
echo ""

rcup -v -x "*.sh" -x "*.md" -x "iterm/com*" -x "config/karabiner"

# must symlink the directory for Karabiner to use the config via dotfiles
ln -s "$HOME"/.dotfiles/config/karabiner "$HOME"/.config
