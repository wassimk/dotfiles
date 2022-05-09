#!/bin/bash

macOS="macOS"
ubuntu="ubuntu"
uname=$(uname -v)

case $uname in
  *Darwin*)
    os=$macOS
    ;;
  *Ubuntu*)
    os=$ubuntu
    ;;
  *)
    echo "ERROR: Don't know how to handle this OS"
    exit 1
esac

installPackageManager() {
  case $os in
    $macOS*)
      if command -v brew >/dev/null 2>&1; then
        updateAvailablePackages
      else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      ;;
    $ubuntu*)
      updateAvailablePackages
      ;;
  esac
}

updateAvailablePackages() {
  case $os in
    $macOS*)
      brew update
      ;;
    $ubuntu*)
      sudo apt-get -y update
      ;;
  esac
}

cleanupPackages() {
  case $os in
    $macOS*)
      brew cleanup
      ;;
    $ubuntu*)
      sudo apt auto-remove -y
      ;;
  esac
}

updateOsPackages() {
  case $os in
    $ubuntu*)
      sudo apt dist-upgrade -y
      ;;
  esac
}

installOnceFromCask() {
  case $os in
    $macOS*)
      if ! brew list -l --cask | grep -q "$1"; then
        brew install --cask "$1"
      fi
      ;;
  esac
}

installOrUpdate() {
  case $os in
    $macOS*)
      if brew list | (grep -q "$1"; ret=$?; cat >/dev/null; exit $ret); then
        if brew outdated | grep -q "$1"; then
          brew upgrade "$1"
        fi
      else
        brew install "$1"
      fi
      ;;
    $ubuntu*)
      sudo apt-get -y install "$1"
      ;;
  esac
}
