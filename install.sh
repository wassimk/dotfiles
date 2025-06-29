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

verifyPrivateFileExists() {
  if [[ ! -f "$HOME/.private" ]]; then
    echo "$HOME/.private file must be present to continue..."
    exit 1
  fi
}

verifyGpgKeyExists() {
  KEY_ID="088BB870EB37CD21"

  if ! gpg --list-secret-keys "$KEY_ID" > /dev/null 2>&1; then
    echo "ERROR: GPG key $KEY_ID not found."
    echo "Export and import it:"
    echo "gpg --export-secret-keys $KEY_ID > private.key"
    echo "gpg --import private.key"
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

setupDotFiles() {
  (cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
}

installDevboxPackages() {
  devbox global add nodejs@latest
  devbox global add ruby@latest
}

installRust() {
  if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y -q --no-modify-path
  else
    rustup update >/dev/null 2>&1;
  fi
}

installNeovim() {
  case $os in
    $macOS*)
      bin/install-neovim.sh nightly
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


installGhExtensions() {
  gh extension install dlvhdr/gh-dash >/dev/null 2>&1;
  gh extension install github/gh-copilot >/dev/null 2>&1;
  gh extension install mloberg/gh-view >/dev/null 2>&1;
  gh extension install seachicken/gh-poi >/dev/null 2>&1;
  gh extension install wassimk/gh-compare >/dev/null 2>&1;
  gh extension install yusukebe/gh-markdown-preview >/dev/null 2>&1;
  gh extensions upgrade --all
}

setupOS() {
  case $os in
    $macOS*)
      brew bundle --file="$HOME"/.dotfiles/Brewfile-macos_apps
      launchctl bootstrap gui/"$(id -u)" "$HOME"/Library/LaunchAgents/com.user.autolights.plist --help >/dev/null 2>&1
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

acceptXcodeLicense() {
  if ! xcodebuild -license check >/dev/null 2>&1; then
    sudo xcodebuild -license accept
  fi
}

miscellaneous() {
  acceptXcodeLicense
  yes | "$(brew --prefix)"/opt/fzf/install >/dev/null 2>&1;
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/*

  ln -s /opt/homebrew/bin/op /usr/local/bin/op >/dev/null 2>&1;
  ln -s ~/.bin/open /usr/local/bin/open >/dev/null 2>&1;

  gem update --system >/dev/null 2>&1;
}

setupNPM() {
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"

  # mason.nvim should be installing this but it doesn't seem to be working
  npm install -g @commitlint/config-conventional >/dev/null 2>&1;

  npm install -g react-devtools >/dev/null 2>&1; # react-devtools for Safari

  npm install -g @anthropic-ai/claude-code 

  npm install -g bugsnag-mcp-server
}

echo ""
echo "Running installation for $os..."
echo ""

verifyPrivateFileExists
verifyGpgKeyExists
installHomebrew
installHomebrewPackages
installDevboxPackages
setupDotFiles
installRust
installNeovim
installGhExtensions
setupOS
setupNPM
miscellaneous

echo ""
echo "Done! You'll probably need to restart your shell/SSH session..."
echo ""
