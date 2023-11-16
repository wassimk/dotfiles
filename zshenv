export VISUAL='nvim'
export EDITOR=$VISUAL
export DOTFILES="$HOME"/.dotfiles

# set to prevent ruby related issue
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Fix for fork issue introduced in macOS High Sierra
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
case "$OSTYPE" in
  darwin*) export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ;;
esac

# local-open sends open commands to client machine while in ssh session
case "$OSTYPE" in
  linux*) export BROWSER='local-open' ;;
esac

#
# Misc
#
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="g *|git *|cd *|ls *|ll *|la *|l *|"
export HOMEBREW_NO_ENV_HINTS=false # no suggestions in the UI
export CARGO_NET_GIT_FETCH_WITH_CLI=true # fix odd github issue
export TEALDEER_CONFIG_DIR="$HOME"/.config/tealdeer # for teeldear (tldr)
export DISABLE_SPRING="1" # more problems than it's worth

#
# Path
#
export PATH=$PATH:$HOME/bin/diff-so-fancy
export PATH=$PATH:$HOME/.bin # from dot files
export PATH=$PATH:"/opt/homebrew/bin" # for Homebrew

#
# Options
#
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_IGNORE_ALL_DUPS    # filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt SHARE_HISTORY           # share history across shells
