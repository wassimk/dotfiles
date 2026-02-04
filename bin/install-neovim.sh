#!/bin/bash

set -e

export GH_TOKEN=${GH_TOKEN:-$(op read "op://System/github/token")}

version=${1:-stable}
file="nvim-macos-arm64.tar.gz"

# Validate inputs
if ! [ "$version" == "nightly" ] && ! [ "$version" == "stable" ]; then
  echo "Must pass 'stable' or 'nightly' for which version to install!"
  exit 1
fi

# Get current version if nvim is installed
current_version=""
if command -v nvim >/dev/null 2>&1; then
  current_version=$(nvim -v | head -n 1)
fi

# Get latest version information
if [ "$version" == "nightly" ]; then
  new_version=$(curl -s "https://api.github.com/repos/neovim/neovim/releases" | jq '[.[] | select(.prerelease == true)] | first' | jq -r '.body' | awk -F"\r" '{print $1}' | sed -n '/NVIM/p')
else
  new_version=$(gh release view --repo neovim/neovim --json body | jq -r '.body' | awk -F"\r" '{print $1}' | sed -n '/NVIM/p' | head -n 1)
fi

# Skip if already on latest version
if [ -n "$current_version" ] && [ "$current_version" == "$new_version" ]; then
  echo "No change in Neovim version. Still running $current_version."
  exit 0
fi

# Download and install
echo "Installing Neovim $version..."
cd /tmp || exit
gh release download "$version" --pattern "$file" --clobber --repo neovim/neovim
xattr -c ./"$file" # avoid macOS not developer signed warnings
tar xzf ./"$file"
rm -f ./"$file"
cd /usr/local/ || exit
sudo rm -rf ./nvim-macos
sudo mv /tmp/nvim-macos-arm64 /usr/local/nvim-macos
sudo ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim

new_version=$(nvim -v | head -n 1)

if [ -n "$current_version" ]; then
  echo "Updated Neovim from $current_version to $new_version."
else
  echo "Installed Neovim $new_version."
fi
