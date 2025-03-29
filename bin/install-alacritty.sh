#!/bin/bash

set -e

# Parse and validate input version argument
version=${1:-latest}
binary="/Applications/Alacritty.app/Contents/MacOS/alacritty"

if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && ! [ "$version" == "latest" ]; then
  echo "Must pass a version tag like '0.12.3' or 'latest' for which version to install!"
  exit 1
fi

# Determine target version to install
if [ "$version" == "latest" ]; then
  target_version=$(gh release list --repo alacritty/alacritty | grep 'Latest' | awk '{print $5}')
else
  target_version=$(gh release list --repo alacritty/alacritty | grep -F "$version" | head -n 1 | awk '{print $8}')
fi

# Verify target version was found
if [ -z "$target_version" ]; then
  echo "Version $version not found!"
  exit 1
fi

# Check for existing installation and version
if [ -f "$binary" ]; then
  old_version=$("$binary" --version 2>/dev/null | awk '{print "v"$2}')
  
  if [ "$old_version" = "$target_version" ]; then
    echo "Alacritty is already on the version $target_version."
    exit 0
  fi
  echo "Updating Alacritty from $old_version to $target_version..."
else
  echo "Installing Alacritty $target_version..."
fi

# Create temporary build directory
temp_dir=$(mktemp -d)
cd "$temp_dir" || exit 1
echo "Downloading Alacritty $target_version..."

# Download source code
wget -O alacritty.zip "https://github.com/alacritty/alacritty/archive/refs/tags/$target_version.zip"
unzip -q -o alacritty.zip
rm alacritty.zip

# Build from source
cd alacritty-"${target_version#v}" || exit 1
echo "Building Alacritty..."
make app

# Install to Applications directory
echo "Installing Alacritty to applications folder..."
cp -r target/release/osx/Alacritty.app /Applications/

# Clean up temporary files
cd .. || exit 1
rm -rf "$temp_dir"

echo "Successfully installed Alacritty $target_version."
