#!/bin/bash

version=${1:-stable}

if [ "$version" == "nightly" ] || [ "$version" == "stable" ]; then
  cd /tmp || exit
  rm -f ./nvim-macos.tar.gz
  rm -rf ./nvim-macos/
  gh release download "$version" --pattern nvim-macos.tar.gz --repo neovim/neovim
  xattr -c ./nvim-macos.tar.gz # avoid macOS not developer signed warnings
  tar xzf ./nvim-macos.tar.gz
  cd /usr/local/ || exit
  sudo rm -rf ./nvim-macos
  sudo mv /tmp/nvim-macos /usr/local/nvim-macos
  ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim
  nvim -v
else
  echo "Must pass 'stable' or 'nightly' for which version to install!"
  exit 1
fi
