#!/bin/bash

source utils.sh

installPackageManager
installOrUpdate "rcm"

cd "$HOME" || exit

echo ""
echo "Installing dot files..."
echo ""

rcup -v -x "*.sh" -x "*.md" -x "iterm/com*" -x "config/karabiner"

# vcs-jump installed by packer plugin manager in vim
vcs_jump_link="$HOME"/.bin/vcs-jump
vcs_jump_cmd="$HOME"/.local/share/nvim/site/pack/packer/start/vcs-jump/bin/vcs-jump
if ! command -v "$vcs_jump_link" >/dev/null 2>&1; then
  if command -v "$vcs_jump_cmd" >/dev/null 2>&1; then
    ln -sf "$vcs_jump_cmd" "$vcs_jump_link"
  fi
fi

# must symlink the directory for these apps
ln -sf "$HOME"/.dotfiles/config/karabiner "$HOME"/.config
ln -sf "$HOME"/.dotfiles/iterm "$HOME"/.config

# config is in a weird spot and i don't want to commit it
espanso_dir="$HOME/Library/Application Support/espanso"
if [ -d $espanso_dir ]; then
  ln -sf  $espanso_dir "$HOME"/.dotfiles/config
fi
