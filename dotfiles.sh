#!/bin/bash

source utils.sh

installPackageManager
installOrUpdate "rcm"

cd "$HOME" || exit

echo ""
echo "Installing dot files..."
echo ""

rcup -v -x "*.sh" -x "*.md" -x "iterm/com*"
