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

# ------------------------------------------------------------------------------
# Pinned versions for devbox global packages.
# Update these when new versions are available:
#   devbox search ruby
#   devbox search nodejs
# ------------------------------------------------------------------------------
RUBY_VERSION="4.0.7"
NODEJS_VERSION="26.11.1"

export GH_TOKEN=${GH_TOKEN:-$(op read "op://System/github/token")}

eval "$(devbox global shellenv 2>/dev/null)"

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
  brew upgrade
}

setupDotFiles() {
  (cd "$HOME"/.dotfiles || exit; bash dotfiles.sh)
}

installDevboxPackages() {
  echo "Installing devbox global packages..."
  echo "  Ruby:   $RUBY_VERSION"
  echo "  NodeJS: $NODEJS_VERSION"
  echo ""
  echo "To update, change RUBY_VERSION and NODEJS_VERSION at the top of this script."
  echo "Run 'devbox search ruby' or 'devbox search nodejs' to find available versions."
  echo ""

  local previous_ruby
  previous_ruby="$(ruby -v 2>/dev/null)"

  devbox global add "ruby@$RUBY_VERSION"
  devbox global add "nodejs@$NODEJS_VERSION"

  # global gems with native extensions link against the exact ruby they were
  # built with, and devbox removes that ruby after an upgrade
  if [ "$(ruby -v 2>/dev/null)" != "$previous_ruby" ]; then
    echo "Ruby changed, rebuilding global gem native extensions..."
    rebuildGlobalGemExtensions
  fi
}

rebuildGlobalGemExtensions() {
  # rubygems itself loads psych and date, which are among the broken gems, so
  # load ruby's bundled copies first or `gem` crashes before it can rebuild.
  # -i keeps pristine out of the read-only nix store, and going one gem at a
  # time stops a gem that can't compile (mysql2, pg) from ending the run
  local gems
  gems="$(ruby --disable-gems -e '
    require "rubygems"
    puts Dir[File.join(ARGV[0], "specifications", "*.gemspec")]
      .filter_map { |f| Gem::Specification.load(f) }
      .reject { |s| s.extensions.empty? }
      .map(&:name).uniq.sort
  ' "$GEM_HOME" 2>/dev/null)"

  for gem in $gems; do
    ruby --disable-gems -W0 -e '
      require "date"
      require "psych"
      require "rubygems"
      require "rubygems/gem_runner"
      Gem::GemRunner.new.run(ARGV)
    ' pristine "$gem" -i "$GEM_HOME" >/dev/null 2>&1 || echo "  could not rebuild $gem"
  done
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

installClaudeCode() {
  if ! command -v claude >/dev/null 2>&1; then
    curl -fsSL https://claude.ai/install.sh | bash
  else
    claude update
  fi
}


installGhExtensions() {
  gh extension install dlvhdr/gh-dash >/dev/null 2>&1;
  gh extension install dlvhdr/gh-enhance >/dev/null 2>&1;
  gh extension install mloberg/gh-view >/dev/null 2>&1;
  gh extension install seachicken/gh-poi >/dev/null 2>&1;
  gh extension install wassimk/gh-compare >/dev/null 2>&1;
  gh extension install github/gh-stack >/dev/null 2>&1;
  gh extension install wassimk/gh-sync >/dev/null 2>&1;
  gh extension install thiagokokada/gh-gfm-preview >/dev/null 2>&1;
  gh extensions upgrade --all
}

setupMacOSDefaults() {
  echo "Setting macOS defaults..."

  # Ghostty: disable macOS menu shortcuts that conflict with herdr keybindings
  defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Settings…" '\0'
  defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Select Previous Split" '\0'
  defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Select Next Split" '\0'
}

setupHerdr() {
  echo "Setting up herdr plugins and integrations..."

  # seamless ctrl-hjkl between neovim splits and herdr panes
  herdr plugin install paulbkim-dev/vim-herdr-navigation --yes >/dev/null 2>&1 || true
  # lets herdr resume claude code sessions after a server restart
  # target ~/.claude (shared by both profiles) even when run from a clp session
  env -u CLAUDE_CONFIG_DIR herdr integration install claude >/dev/null 2>&1 || true
}

cleanupHomebrew() {
  brew cleanup

  # report, don't remove: anything installed by hand shows up here until it's
  # added to a Brewfile or uninstalled
  local undeclared
  undeclared="$(cat "$HOME"/.dotfiles/Brewfile "$HOME"/.dotfiles/Brewfile-macos_apps | brew bundle cleanup --file=- 2>/dev/null)"
  if [ -n "$undeclared" ]; then
    echo ""
    echo "WARNING: installed but not in a Brewfile:"
    echo "$undeclared" | grep -v '^Run '
    echo ""
  fi
}

setupOS() {
  case $os in
    $macOS*)
      brew bundle --file="$HOME"/.dotfiles/Brewfile-macos_apps
      brew upgrade --cask
      cleanupHomebrew
      elgato-autolight install 2>/dev/null || true
      tmignore install 2>/dev/null || true
      granary install 2>/dev/null || true
      setupMacOSDefaults
      setupHerdr
      ;;
    $ubuntu*)
      sudo timedatectl set-timezone America/Chicago
      sudo apt-get -y update
      sudo apt dist-upgrade -y
      sudo apt auto-remove -y
      ;;
  esac

}

acceptXcodeLicense() {
  if ! xcodebuild -license check >/dev/null 2>&1; then
    sudo xcodebuild -license accept
  fi
}

checkMonoLisa() {
  bin/check-monolisa
}

checkSudoTouchID() {
  local sudo_local="/etc/pam.d/sudo_local"

  if [[ ! -f "$sudo_local" ]] || ! grep -q "pam_tid.so" "$sudo_local"; then
    echo ""
    echo "WARNING: sudo Touch ID authentication is not configured."
    echo ""
    echo "  Create/edit $sudo_local (requires sudo):"
    echo "    sudo vim $sudo_local"
    echo ""
    echo "  Add these lines:"
    echo "    auth       optional       /opt/homebrew/lib/pam/pam_reattach.so"
    echo "    auth       sufficient     pam_tid.so"
    echo ""
    echo "  The pam_reattach line is needed for Touch ID to work inside herdr panes"
    echo "  (the herdr server is a background process)."
    echo "  Install it first: brew install pam-reattach"
    echo ""
  elif ! grep -q "pam_reattach.so" "$sudo_local"; then
    echo ""
    echo "WARNING: sudo Touch ID is configured but pam_reattach is missing."
    echo "  Touch ID won't work inside herdr panes without it."
    echo ""
    echo "  Install: brew install pam-reattach"
    echo "  Then add this line BEFORE the pam_tid.so line in $sudo_local:"
    echo "    auth       optional       /opt/homebrew/lib/pam/pam_reattach.so"
    echo ""
  else
    echo "✔ sudo Touch ID configuration exists"
  fi
}

miscellaneous() {
  acceptXcodeLicense
  yes | "$(brew --prefix)"/opt/fzf/install >/dev/null 2>&1;
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/*

  gem update --system >/dev/null 2>&1;
}

setupNPM() {
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global"
  npm install -g npm@latest >/dev/null 2>&1;

  # mason.nvim should be installing this but it doesn't seem to be working
  npm install -g @commitlint/config-conventional >/dev/null 2>&1;

  npm install -g react-devtools >/dev/null 2>&1; # react-devtools for Safari
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
installClaudeCode
installGhExtensions
setupOS
setupNPM
miscellaneous
checkSudoTouchID
checkMonoLisa

echo ""
echo "Done! You'll probably need to restart your shell/SSH session..."
echo ""
