# Fix for fork issue introduced in macOS High Sierra
# https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

# Load SSH keys stored in macOS Keychain
ssh-add -A 2>/dev/null

# Brew auto-complete
# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Load oh-my-zsh plugins, auto-completion, themes, etc.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="wassimk"
plugins=(bundler gem tmuxinator encode64 jsontools urltools z autojump)
source $ZSH/oh-my-zsh.sh

# zplug plugin manager
source ~/.zplug/init.zsh
export NVM_AUTO_USE=true
zplug "lukechilds/zsh-nvm"

# Upgrade oh-my-zsh without asking
DISABLE_UPDATE_PROMPT=true

# Add bin directories to path
export PATH=$PATH:bin # current folder
export PATH=$PATH:$HOME/bin/diff-so-fancy
export PATH=$PATH:$HOME/.dotfiles/bin # my dot files
export PATH=$PATH:$HOME/.cargo/bin # Rust cargo
export PATH=$PATH:/usr/local/sbin # brew complained about this

# Sourcing of other files
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.zsh/colors
source $HOME/.private
source ~/.bin/tmuxinator.zsh

# For Yarn and NPM with Brew Node
# https://gist.github.com/DanHerbert/9520689
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$(yarn global bin):$PATH"

# Source ZSH Syntax Highlighting
# First install with brew install zsh-syntax-highlighting
#
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# disabled until can load it on ubuntu which is in /usr/share/zsh-syntax/highlighting

# fzf auto-complete searching
# brew install fzf first
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ignore duplicate commands pushed to history mostly for fzf usage
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# Planning Center
export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_PORT=3307
export PATH=$HOME/pco-box/bin:/usr/local/bin:$PATH
export RBENV_ROOT=$HOME/.rbenv
eval "$($HOME/Code/pco/bin/pco init -)"
eval "$(rbenv init -)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
