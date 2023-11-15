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

createPrivateFiles() {
  touch "$HOME"/.private
}

installPackageManager() {
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -d "/opt/homebrew" ]; then 
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  else
    brew update
  fi
}

installPackages() {
  brew bundle
}

setupDotFiles() {
  (cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
}

setupRuby() {
  rbenv install 3.2.2 --skip-existing
  rbenv global 3.2.2
}

installRust() {
  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y -q --no-modify-path
  else
    rustup update
  fi
}

installEditor() {
  case $os in
    $macOS*)
      bin/install-neovim.sh stable
      ;;
    $ubuntu*)
      if ! command -v nvim >/dev/null 2>&1; then
        sudo snap install nvim --classic
      else
        sudo snap refresh nvim --classic
      fi

      ;;
  esac
}

installTerminal() {
  case $os in
    $macOS*)
      bin/install-alacritty.sh latest
      ;;
  esac
}

installGhExtensions() {
  gh extension install dlvhdr/gh-dash
  gh extension install mloberg/gh-view
  gh extension install seachicken/gh-poi
  gh extension install yusukebe/gh-markdown-preview
  gh extensions upgrade --all
}

setupOS() {
  case $os in
    $macOS*)
      echo -e "Make sure you've launched the Mac App Store and signed into your accounts!"
      echo -e "Type 'done' when you're ready to continue."
      read -r confirm
      if [ "$confirm" != "done" ] ; then
        echo "Glad I asked! Bye."
        exit 1
      else
        brew bundle --file="$HOME"/.Brewfile-macos_apps
      fi

      mackup restore
      ;;
    $ubuntu*)
      sudo timedatectl set-timezone America/Chicago
      sudo apt-get -y update
      sudo apt dist-upgrade -y
      sudo apt auto-remove -y
      ;;
  esac

  brew cleanup
}

echo ""
echo "Running installation for $os..."
echo ""

createPrivateFiles
installPackageManager
installPackages
setupDotFiles
setupRuby
installRust
installEditor
installTerminal
installGhExtensions
setupOS

echo ""
echo "Done! You'll probably need to restart your shell/SSH session..."
echo ""
