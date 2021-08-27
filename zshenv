# Fix for fork issue introduced in macOS High Sierra
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
case "$OSTYPE" in
  darwin*) export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES ;;
esac

# Add bin directories to path
export PATH=$PATH:$HOME/bin/diff-so-fancy
export PATH=$PATH:$HOME/.bin # from dot files
export PATH=$PATH:"/usr/local/sbin" # for Homebrew

# Ignore duplicate commands pushed to history mostly for fzf usage
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
