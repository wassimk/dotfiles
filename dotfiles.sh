#!/bin/bash

cd "$HOME" || exit

echo ""
echo "Installing dot files..."
echo ""

rcup -v -x "./*.sh" -x "*.md" -x "*.log" -x "iterm/com*" -x "config/karabiner" -x "config/lazygit*" -x "Library/Keybindings" -x "Library/LaunchAgents" -x "Brewfile*"

# vcs-jump installed by lazy plugin manager in vim
vcs_jump_link="$HOME"/.bin/vcs-jump
vcs_jump_cmd="$HOME"/.local/share/nvim/lazy/vcs-jump/bin/vcs-jump
if ! command -v "$vcs_jump_link" >/dev/null 2>&1; then
  if command -v "$vcs_jump_cmd" >/dev/null 2>&1; then
    ln -sf "$vcs_jump_cmd" "$vcs_jump_link"
  fi
fi

# must symlink the directory for these apps
ln -sf "$HOME"/.dotfiles/config/karabiner "$HOME"/.config
ln -sf "$HOME"/.dotfiles/iterm "$HOME"/.config

# copy Library files to ~/Library
echo "Copying Library files..."
find "$HOME/.dotfiles/Library" -type f | while read -r file; do
  relative_path="${file#"$HOME"/.dotfiles/Library/}"
  target_dir="$HOME/Library/$(dirname "$relative_path")"
  target_file="$HOME/Library/$relative_path"

  # create target directory if it doesn't exist
  mkdir -p "$target_dir"

  # copy file, replacing if it exists
  cp "$file" "$target_file" >/dev/null 2>&1
  echo "Copied: $relative_path"
done

# lazygit config wants to live somewhere odd, let's symlink it
real_lazygit_config_dir="$HOME/Library/Application Support/lazygit"
lazygit_config_file="$HOME/.dotfiles/config/lazygit/config.yml"
if [ -d "$real_lazygit_config_dir" ]; then
  ln -sf "$lazygit_config_file" "$real_lazygit_config_dir/config.yml"
fi

# symlink works Code directory
(cd "$HOME" || exit; ln -sf Code Work)

echo ""
echo "Cleaning up broken symlinks..."
echo ""
find -L "$HOME" -maxdepth 1 -type l -not -path "$HOME/.nix-profile" -exec rm -i {} \;
find -L "$HOME/.bin" -type l -exec rm -i {} \;
find -L "$HOME/.config" -type l -exec rm -i {} \;
find -L "$HOME/.hammerspoon" -type l -exec rm -i {} \;
find -L "$HOME/.zsh" -type l -exec rm -i {} \;
