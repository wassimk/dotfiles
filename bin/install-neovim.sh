#!/bin/bash

version=${1:-stable}

if ! [ "$version" == "nightly" ] && ! [ "$version" == "stable" ]; then
  echo "Must pass 'stable' or 'nightly' for which version to install!"
  exit 1
fi
 
current_version=$(nvim -v | head -n 1)
new_version=""

if [ "$version" == "nightly" ]; then
  new_version=$(curl -s "https://api.github.com/repos/neovim/neovim/releases" | jq '[.[] | select(.prerelease == true)] | first' | jq -r '.body' | awk -F"\r" '{print $1}' | sed -n '/NVIM/p')
else
  new_version=$(gh release view --repo neovim/neovim --json body | jq -r '.body' | awk -F"\r" '{print $1}' | sed -n '/NVIM/p' | head -n 1)
fi

if [ "$current_version" == "$new_version" ]; then
  echo "No change in Neovim version. Still running $current_version."
  exit 1
fi

file="nvim-macos-arm64.tar.gz"

cd /tmp || exit
gh release download "$version" --pattern $file --clobber --repo neovim/neovim
xattr -c ./$file # avoid macOS not developer signed warnings
tar xzf ./$file
rm -f ./$file
cd /usr/local/ || exit
sudo rm -rf ./nvim-macos
sudo mv /tmp/nvim-macos-arm64 /usr/local/nvim-macos
sudo ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim


new_version=$(nvim -v | head -n 1) 

echo "Updated Neovim from $current_version to $new_version."
