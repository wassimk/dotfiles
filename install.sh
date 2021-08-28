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
  # TODO: install a version and do some setup? right now other work tools do this.
}

installRust() {
  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y -q --no-modify-path
  else
    rustup update
  fi
}

installGnuPg() {
  installOrUpdate "gnupg"
}

installClipper() {
  case $os in
    $macOS*)
      installOrUpdate "clipper"
      ;;
  esac
}

installZsh() {
  installOrUpdate "zsh"

  if [[ $SHELL != *zsh* ]]; then
    sudo chsh -s "$(command -v zsh)" "$(whoami)"
  fi
}

installOMZsh() {
  if [ ! -d "$HOME"/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --skip-chsh --keep-zshrc
  else
    omz update
  fi
}

installZshSyntaxHighlighting() {
  installOrUpdate "zsh-syntax-highlighting"
}

installReadline() {
  case $os in
    $macOS*)
      installOrUpdate "readline"
      ;;
    $ubuntu*)
      installOrUpdate "readline8"
      ;;
  esac
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

installRg() {
  case $os in
    $macOS*)
      installOrUpdate "ripgrep"
      ;;
    $ubuntu*)
      # https://github.com/sharkdp/bat/issues/938
      sudo apt -y install -o Dpkg::Options::="--force-overwrite" ripgrep
      ;;
  esac

}

installAck() {
  installOrUpdate "ack"
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
      if ! command -v gh >/dev/null 2>&1; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        updateAvailablePackages
      fi
      ;;
  esac

  installOrUpdate "gh"
}

installHeroku() {
  case $os in
    $macOS*)
      installOrUpdate "heroku"
      ;;
  esac
}

installAwsCli() {
  case $os in
    $macOS*)
      installOrUpdate "awscli"
      ;;
    $ubuntu*)
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip -q awscliv2.zip
      if ! command -v aws >/dev/null 2>&1; then
        sudo ./aws/install
      else
        sudo ./aws/install --update
      fi

      rm -rf aws
      rm awscliv2.zip
      ;;
  esac
}

installStripeCli() {
  case $os in
    $macOS*)
      installOrUpdate "stripe"
      ;;
    $ubuntu*)
      if ! command -v stripe >/dev/null 2>&1; then
        cd "/usr/local/bin" || exit
        sudo wget -O stripe-cli.tar.gz "https://github.com/stripe/stripe-cli/releases/download/v1.7.0/stripe_1.7.0_linux_x86_64.tar.gz"
        sudo tar -xvf stripe-cli.tar.gz
        sudo rm stripe-cli.tar.gz
      fi
      ;;
  esac
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
      if ! command -v exa >/dev/null 2>&1; then
        cd "/usr/local" || exit
        sudo wget https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip -O exa.zip
        sudo unzip exa.zip -d exa
        sudo rm exa.zip
        ln -sf /usr/local/exa/bin/exa /usr/local/bin/exa
      fi
      ;;
  esac
}

installBat() {
  case $os in
    $macOS*)
      installOrUpdate "bat"
      ;;
    $ubuntu*)
      # https://github.com/sharkdp/bat/issues/938
      sudo apt -y install -o Dpkg::Options::="--force-overwrite" bat
      ln -sf /usr/bin/batcat /usr/local/bin/bat
      ;;
  esac
}

installDiffSoFancy() {
  case $os in
    $macOS*)
      installOrUpdate "diff-so-fancy"
      ;;
    $ubuntu*)
      if ! command -v diff-so-fancy >/dev/null 2>&1; then
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

  if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim --headless +PlugInstall +qall
  else
    nvim --headless +PlugUpdate +qall
  fi
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
# installGo
installRuby
# installRust
installGnuPg
installClipper
installZsh
installOMZsh
installZshSyntaxHighlighting
installReadline
installFzf
installAg
installRg
installAck
installCtags
installGrc
installHub
installGh
installHeroku
# installAwsCli
installStripeCli
installTree
installExa
installBat
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
