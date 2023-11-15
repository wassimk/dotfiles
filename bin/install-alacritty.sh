#!/bin/bash

version=${1:-latest}
binary="/Applications/Alacritty.app/Contents/MacOS/alacritty"

if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [ "$version" == "latest" ]; then
  echo "Must pass a version tag like '0.12.3' or 'latest' for which version to install!"
  exit 1
fi

if [ "$version" == "latest" ]; then
  target_version=$(gh release list --repo alacritty/alacritty | grep 'Latest' | awk '{print $5}')
else
  target_version=$(gh release list --repo alacritty/alacritty | awk '{print $8}' | grep "$version" | head -n 1)
fi

if [ -z "$target_version" ]; then
  echo "Version $version not found!"
  exit 1
fi

old_version=$("$binary" --version 2>/dev/null | awk '{print "v"$2}')

if [ "$old_version" = "$target_version" ]; then
  echo "Alacritty is already on the version $target_version."
  exit 0
fi

cd /tmp || exit
wget -O alacritty.zip "https://github.com/alacritty/alacritty/archive/refs/tags/$target_version.zip"
unzip -o alacritty.zip
rm alacritty.zip
cd alacritty-"${target_version#v}" || exit
make app
cp -r target/release/osx/Alacritty.app /Applications/
cd ../ || exit
rm -rf alacritty-"${target_version#v}"

echo "Successfully updated Alacritty from $old_version to $target_version."

