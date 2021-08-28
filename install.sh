#!/bin/bash

source utils.sh

createPrivateFiles() {
  touch "$HOME"/.private
}

installGit() {
  installOrUpdate "git"
}

installGo() {
  case $os in
    $macOS*)
      installOrUpdate "go"
      ;;
    $ubuntu*)
      installOrUpdate "golang-go"
      ;;
  esac
}

installRuby() {
  installOrUpdate "rbenv"
}

installGnuPg() {
  installOrUpdate "gnupg"
}

installZsh() {
  installOrUpdate "zsh"

  sudo chsh -s "$(command -v zsh)" "$(whoami)"
}

installOMZsh() {
  if [ ! -d "$HOME"/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

installZshSyntaxHighlighting() {
  installOrUpdate "zsh-syntax-highlighting"
}

installFzf() {
  installOrUpdate "fzf"
}

installAg() {
  case $os in
    $macOS*)
      installOrUpdate "the_silver_searcher"
      ;;
    $ubuntu*)
      installOrUpdate "silversearcher-ag"
      ;;
  esac
}

installCtags() {
  installOrUpdate "ctags"
}

installGrc() {
  installOrUpdate "grc"
}

installHub() {
  installOrUpdate "hub"
}

installGh() {
  case $os in
    $ubuntu*)
      if ! command -v gh 2>&1 >/dev/null; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        updateAvailablePackages
      fi
      ;;
  esac

  installOrUpdate "gh"
}

installTree() {
  installOrUpdate "tree"
}

installWget() {
  installOrUpdate "wget"
}

installExa() {
  case $os in
    $macOS*)
      installOrUpdate "exa"
      ;;
    $ubuntu*)
      if ! command -v exa; then
        cd "/usr/local" || exit
        sudo wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O exa.zip
        sudo unzip exa.zip -d exa
        sudo rm exa.zip
        ln -sf /usr/local/exa/bin/exa /usr/local/bin/exa
      fi
      ;;
  esac
}

installDiffSoFancy() {
  case $os in
    $macOS*)
      installOrUpdate "diff-so-fancy"
      ;;
    $ubuntu*)
      if ! command -v diff-so-fancy; then
        cd "/usr/local" || exit
        sudo git clone https://github.com/so-fancy/diff-so-fancy.git
        ln -s /usr/local/diff-so-fancy/diff-so-fancy /usr/local/bin/diff-so-fancy
      else
        cd "/usr/local/diff-so-fancy" || exit
        sudo git pull
      fi
  esac
}

installTrash() {
  case $os in
    $macOS*)
      installOrUpdate "trash"
      ;;
  esac
}

installShellCheck() {
  installOrUpdate "shellcheck"
}

installSshCopyId() {
  case $os in
    $macOS*)
      installOrUpdate "ssh-copy-id"
      ;;
  esac
}

installBattery() {
  case $os in
    $macOS*)
      installOrUpdate "spark"
      brew tap Goles/battery
      installOrUpdate "battery"
      ;;
  esac
}

installNeovim() {
  installOrUpdate "neovim"
}

installTmux() {
  installOrUpdate "tmux"
}

setupNeovim() {
  mkdir -p ~/.config/nvim/
  ln -sf ~/.vimrc ~/.config/nvim/init.vim
}

miscellaneousSetup() {
  ln -sf ~/Code ~/Work
}

echo ""
echo "Running installation for $os..."
echo ""

createPrivateFiles
installPackageManager
updateAvailablePackages
updateOsPackages
installWget
installGit
installGo
installRuby
installGnuPg
installZsh
installOMZsh
installZshSyntaxHighlighting
installFzf
installAg
installCtags
installGrc
installHub
installGh
installTree
installExa
installDiffSoFancy
installTrash
installShellCheck
installSshCopyId
installBattery
installNeovim
installTmux
cleanupPackages
(cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
setupNeovim
miscellaneousSetup
bash "$HOME/.bin/ctags_init"
