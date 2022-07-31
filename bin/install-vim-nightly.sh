#!/bin/bash

cd /tmp
rm nvim-macos.tar.gz
rm -rf nvim-macos/
gh release download nightly --pattern nvim-macos.tar.gz --repo neovim/neovim
tar xzvf nvim-macos.tar.gz
cd /usr/local/
sudo rm -rf nvim-macos
sudo mv /tmp/nvim-macos/ /usr/local/nvim-macos
ln -sf /usr/local/nvim-macos/bin/nvim /usr/local/bin/nvim
