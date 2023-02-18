export VISUAL='nvim'
export EDITOR=$VISUAL
export DOTFILES="$HOME"/.dotfiles

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
export HOMEBREW_NO_GOOGLE_ANALYTICS=true # no analytics to Google
export CARGO_NET_GIT_FETCH_WITH_CLI=true # fix odd github issue

#
# Path
#
export PATH=$PATH:$HOME/bin/diff-so-fancy
export PATH=$PATH:$HOME/.bin # from dot files
export PATH=$PATH:"/usr/local/sbin" # for Homebrew

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
