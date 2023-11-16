#!/bin/bash

RUBY_VERSION=3.2.2
NODE_VERSION=18.16.0

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

verifyPrivateFileExists() {
  if [[ ! -f "$HOME/.private" ]]; then
    echo "$HOME/.private file must be present to continue..."
    exit 1
  fi
}

installHomebrew() {
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

installHomebrewPackages() {
  brew bundle
}

installAsdf() {
  if command -v asdf >/dev/null 2>&1; then
    asdf update
    asdf plugin update nodejs
    asdf plugin update alias
    echo "nodejs $NODE_VERSION" >> "$HOME"/.tool-versions
  else
    git clone https://github.com/asdf-vm/asdf.git "$HOME"/.asdf --branch v0.11.1
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf plugin add alias https://github.com/andrewthauer/asdf-alias.git
    asdf install nodejs $NODE_VERSION
  fi
}

setupDotFiles() {
  (cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
}

setupRuby() {
  rbenv install $RUBY_VERSION --skip-existing
  rbenv global $RUBY_VERSION
}

installRust() {
  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y -q --no-modify-path
  else
    rustup update
  fi
}

installNeovim() {
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

miscellaneous() {
  yabai --restart-service
  skhd --restart-service
  sudo xcodebuild -license accept
  yes | "$(brew --prefix)"/opt/fzf/install >/dev/null 2>&1;
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/*
}

echo ""
echo "Running installation for $os..."
echo ""

verifyPrivateFileExists
installHomebrew
installHomebrewPackages
installAsdf
setupDotFiles
setupRuby
installRust
installNeovim
installTerminal
installGhExtensions
setupOS
miscellaneous

echo ""
echo "Done! You'll probably need to restart your shell/SSH session..."
echo ""
