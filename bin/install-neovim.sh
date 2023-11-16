#!/bin/bash

version=${1:-stable}

if ! [ "$version" == "nightly" ] && ! [ "$version" == "stable" ]; then
  echo "Must pass 'stable' or 'nightly' for which version to install!"
  exit 1
fi

old_version=$(nvim -v | head -n 1) 

cd /tmp || exit
gh release download "$version" --pattern nvim-macos.tar.gz --repo neovim/neovim
xattr -c ./nvim-macos.tar.gz # avoid macOS not developer signed warnings
tar xzf ./nvim-macos.tar.gz
rm -f ./nvim-macos.tar.gz
cd /usr/local/ || exit
sudo rm -rf ./nvim-macos
sudo mv /tmp/nvim-macos /usr/local/nvim-macos
sudo ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim

new_version=$(nvim -v | head -n 1) 

if [ "$old_version" != "$new_version" ]; then
  echo "Updated Neovim from $old_version to $new_version."
else
  echo "No change in Neovim version. Still running $old_version."
fi
