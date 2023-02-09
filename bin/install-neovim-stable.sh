#!/bin/bash

cd /tmp || exit
rm ./nvim-macos.tar.gz
rm -rf ./nvim-macos/
gh release download stable --pattern nvim-macos.tar.gz --repo neovim/neovim
xattr -c ./nvim-macos.tar.gz # avoid macOS not developer signed warnings
tar xzvf ./nvim-macos.tar.gz
cd /usr/local/ || exit
sudo rm -rf ./nvim-macos
sudo mv /tmp/nvim-macos /usr/local/nvim-macos
ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim
