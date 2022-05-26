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

  rbenv install 2.7 --skip-existing
  rbenv global 2.7
}

installPython() {
  installOrUpdate "python"

  case $os in
    $ubuntu*)
      installOrUpdate "python3"
      installOrUpdate "python3-pip"
      ;;
  esac
}

installJava() {
  case $os in
    $macOS*)
      installOrUpdate "openjdk"
      if ! [ -L "/Library/Java/JavaVirtualMachines/openjdk.jdk" ] ; then
        echo "Symlinking brew's version of Java..."
        sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
      fi
      ;;
  esac
}

installRust() {
  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y -q --no-modify-path
  else
    rustup update
  fi
}

installGnuPg() {
  case $os in
    $macOS*)
      brew install --cask gpg-suite-no-mail
      ;;
    $ubuntu*)
      installOrUpdate "gnupg"
      ;;
  esac
}

installClipper() {
  case $os in
    $macOS*)
      installOrUpdate "clipper"
      ;;
  esac
}

installHammerspoon() {
  case $os in
    $macOS*)
      installOnceFromCask "hammerspoon"
      ;;
  esac
}

installKarabinerElements() {
  case $os in
    $macOS*)
      installOnceFromCask "karabiner-elements"
      ;;
  esac
}

installDropbox() {
  case $os in
    $macOS*)
      installOnceFromCask "dropbox"
      ;;
  esac
}

installITerm() {
  case $os in
    $macOS*)
      installOnceFromCask "iterm2"
      ;;
  esac
}

installZsh() {
  installOrUpdate "zsh"

  if [[ $SHELL != *zsh* ]]; then
    sudo chsh -s "$(command -v zsh)" "$(whoami)"
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

installJq() {
  installOrUpdate "jq"
}

installCtags() {

  case $os in
    $macOS*)
      installOrUpdate "universal-ctags"
      ;;
    $ubuntu*)
      if ! command -v universal-ctags >/dev/null 2>&1; then
        sudo apt remove exuberant-ctags -y

        cd "$HOME" || exit
        git clone https://github.com/universal-ctags/ctags.git
        cd ctags || exit
        ./autogen.sh
        ./configure
        make && make install
        cd ../
        rm -rf ctags
      else
        sudo snap refresh universal-ctags
      fi
      ;;
  esac
}

installGrc() {
  installOrUpdate "grc"
}

installHub() {
  installOrUpdate "hub"
}

installGh() {
  case $os in
    $macOS*)
      installOrUpdate "gh"
      ;;
    $ubuntu*)
      if ! command -v gh >/dev/null 2>&1; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        updateAvailablePackages
      fi

      installOrUpdate "gh"

      gh completion -s zsh | sudo tee /usr/local/share/zsh/site-functions/_gh > /dev/null
      ;;
  esac
}

installTig() {
  case $os in
    $macOS*)
      installOrUpdate "tig"
      ;;
    $ubuntu*)
      if ! command -v tig >/dev/null 2>&1; then
        gh release download --pattern "tig-*.tar.gz" --repo jonas/tig
        tar -xvf tig-*.tar.gz
        cd tig-*/ || exit
        make prefix=/usr/local
        sudo make install prefix=/usr/local
        cd ..
        rm -rf tig-*/
        rm tig-*.tar.gz
      fi
      ;;
  esac
}

installTerminal() {
  case $os in
    $macOS*)
      installOnceFromCask "alacritty"
      ;;
  esac
}

installTerminalPrompt() {
  case $os in
    $macOS*)
      installOrUpdate "starship"
      ;;
    $ubuntu*)
      curl -sS https://starship.rs/install.sh | sh
      ;;
  esac
}
installWindowManager() {
  case $os in
    $macOS*)
      if ! command -v yabai >/dev/null 2>&1; then
        installOrUpdate "koekeishiya/formulae/yabai"

        echo -e "You need to disable SIP and do some other hackery to get this loading on macOS"
        echo -e "https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)"
        echo -e "Type 'OK' to acknowledge this!"
        read -r confirm
        if [ "$confirm" != "OK" ] ; then
          echo "Get it done! Exiting."
          exit 1
        fi
      else
        brew services stop yabai
        brew upgrade yabai
        brew services start yabai

        sudo yabai --uninstall-sa
        sudo yabai --install-sa

        killall Dock
      fi
      ;;
  esac
}

installShortcutManager() {
  case $os in
    $macOS*)
      if ! command -v skhd >/dev/null 2>&1; then
        installOrUpdate "koekeishiya/formulae/skhd"
        brew services start skhd
      fi
      ;;
  esac
}

installHeroku() {
  case $os in
    $macOS*)
      if ! command -v heroku >/dev/null 2>&1; then
        curl https://cli-assets.heroku.com/install.sh | sh
      fi
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
        gh release download --pattern "stripe_*_linux_x86_64.tar.gz" --repo stripe/stripe-cli
        sudo tar -xvf stripe_*_linux_x86_64.tar.gz
        sudo rm stripe_*_linux_x86_64.tar.gz
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
        cd "$HOME" || exit
        gh release download --pattern "exa-linux-x86_64-v*.zip" --repo ogham/exa
        unzip -o exa-linux-x86_64-v*.zip -d exa
        rm exa-linux-x86_64-v*.zip
        sudo rm -rf /usr/local/exa
        sudo mv exa /usr/local
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
      if ! command -v bat >/dev/null 2>&1; then
        ln -sf /usr/bin/batcat /usr/local/bin/bat
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
    $ubuntu*)
      installOrUpdate "openssh-client"
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

installAsimov() {
  case $os in
    $macOS*)
      if ! command -v asimov >/dev/null 2>&1; then
        installOrUpdate "asimov"
        sudo brew services start asimov
      else
        installOrUpdate "asimov"
      fi
      ;;
  esac
}

installNeovim() {
  case $os in
    $macOS*)
      installOrUpdate "neovim"
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

installTmux() {
  installOrUpdate "tmux"
}

fixTmux256ColorTerm() {
  curl -OL https://gist.githubusercontent.com/nicm/ea9cf3c93f22e0246ec858122d9abea1/raw/37ae29fc86e88b48dbc8a674478ad3e7a009f357/tmux-256color
  echo '8f259a31649900b9a8f71cbc28be762aa55206316d33d51fd8d08e4275b5f6a3  tmux-256color' | shasum -a 256 -c
  if [ $? == 0 ]
  then
    /usr/bin/tic -x tmux-256color
  else
    echo 'tmux-256color checksum has changed'
  fi
  rm tmux-256color
}

installItermShellIntegration() {
  if [ ! -f "$HOME"/.iterm2_shell_integration.zsh ]; then
    curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
  fi
}

setupNeovim() {
  mkdir -p "$HOME"/.config/nvim/

  if [ ! -f "$HOME"/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
    pip3 install neovim
    yarn global add neovm
  else
    pip3 install neovim --upgrade
    yarn global upgrade neovm
  fi

  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

miscellaneousSetup() {
  case $os in
    $ubuntu*)
      sudo timedatectl set-timezone America/Chicago
      ;;
  esac

  (cd "$HOME" || exit; ln -sf Code Work)
}

echo ""
echo "Running installation for $os..."
echo ""

createPrivateFiles
installPackageManager
updateAvailablePackages
updateOsPackages
installWget
installGh
installGit
installGo
installRuby
installPython
installJava
# installRust
installHammerspoon
installKarabinerElements
installDropbox
installITerm
installGnuPg
installClipper
installZsh
installZshSyntaxHighlighting
installReadline
installFzf
installAg
installRg
installAck
installJq
installCtags
installGrc
installHub
installTig
installTerminal
installWindowManager
installShortcutManager
installHeroku
installAwsCli
installStripeCli
installTree
installExa
installBat
installDiffSoFancy
installTrash
installShellCheck
installSshCopyId
installBattery
installAsimov
installNeovim
installTmux
fixTmux256ColorTerm
installItermShellIntegration
cleanupPackages
(cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
setupNeovim
miscellaneousSetup

echo ""
echo "Done! You'll probably need to restart your shell/SSH session..."
echo ""
