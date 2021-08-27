#!/bin/bash

source utils.sh

createPrivateFiles() {
  touch $HOME/.private
}

installGit() {
  case $os in
    $macOS)
      brew install git
      ;;
    $ubuntu)
      sudo apt-get -y install git
      ;;
  esac
}

installGo() {
  case $os in
    $macOS)
      brew install go
      ;;
    $ubuntu)
      sudo apt-get -y install golang-go
      ;;
  esac
}

installRuby() {
  case $os in
    $macOS)
      brew install rbenv
      ;;
    $ubuntu)
      sudo apt-get -y install rbenv
      ;;
  esac
}

installZsh() {
  case $os in
    $macOS)
      brew install zsh
      ;;
    $ubuntu)
      sudo apt-get install -y zsh
      ;;
  esac

  sudo chsh $(whoami) -s $(which zsh)
}

installOMZsh() {
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

installZshSyntaxHighlighting() {
  case $os in
    $macOS)
      brew install zsh-syntax-highlighting
      ;;
    $ubuntu)
      sudo apt-get install -y zsh-syntax-highlighting
      ;;
  esac
}

installFzf() {
  case $os in
    $macOS)
      brew install fzf
      ;;
    $ubuntu)
      sudo apt-get install -y fzf
      ;;
  esac
}

installAg() {
  case $os in
    $macOS)
      brew install the_silver_searcher
      ;;
    $ubuntu)
      sudo apt-get -y install silversearcher-ag
      ;;
  esac
}

installCtags() {
  case $os in
    $macOS)
      brew install ctags
      ;;
    $ubuntu)
      sudo apt-get -y install ctags
      ;;
  esac
}

installGh() {
  case $os in
    $macOS)
      brew install gh
      ;;
    $ubuntu)
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt update
      sudo apt install gh
      ;;
  esac
}

installGrc() {
  case $os in
    $macOS)
      brew install grc
      ;;
    $ubuntu)
      sudo apt-get install -y grc
      ;;
  esac
}

installHub() {
  case $os in
    $macOS)
      brew install hub
      ;;
    $ubuntu)
      sudo apt-get -y install hub
      ;;
  esac
}

installNeovim() {
  case $os in
    $macOS)
      brew install neovim
      ;;
    $ubuntu)
      sudo apt-get -y install neovim
      ;;
  esac
}

installTmux() {
  case $os in
    $macOS)
      brew install tmux
      ;;
    $ubuntu)
      sudo apt-get -y install tmux
      ;;
  esac
}

setupNeovim() {
  mkdir -p ~/.config/nvim/
  ln -s ~/.vimrc ~/.config/nvim/init.vim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim -c "PlugInstall"
  read e
  echo $e
}

miscellaneousSetup() {
  ln -s ~/Code ~/Work
}

echo "Running installation for $os..."
createPrivateFiles
installPackageManager
updateAvailablePackages
installGit
installGo
installRuby
installZsh
installOMZsh
installZshSyntaxHighlighting
installFzf
installAg
installCtags
installGrc
installHub
installGh
installNeovim
installTmux
(cd "$HOME" || exit; bin/bash dotfiles.sh)
setupNeovim
miscellaneousSetup
bin/bash "$HOME/.bin/ctags_init"
