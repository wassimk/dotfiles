# Use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

# Load SSH keys stored in macOS Keychain
ssh-add -A 2>/dev/null

# Load oh-my-zsh plugins, auto-completion, themes, etc.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="wassimk"
plugins=(rails bundler gem npm tmuxinator encode64 jsontools urltools)
source $ZSH/oh-my-zsh.sh

# Upgrade oh-my-zsh without asking
DISABLE_UPDATE_PROMPT=true

# Add current directory bin
export PATH=$PATH:bin

# Add my own dotfiles bin
export PATH=$PATH:$HOME/.dotfiles/bin

# Sourcing of other files
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.bin/tmuxinator.zsh
source $HOME/.zsh/colors

# For Yarn and NPM with Brew Node
# https://gist.github.com/DanHerbert/9520689
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH="$PATH:`yarn global bin`"

# Source ZSH Syntax Highlighting
# First install with brew install zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
