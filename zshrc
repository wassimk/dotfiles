# Use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

# Load oh-my-zsh plugins, auto-completion, themes, etc.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="wassimk"
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

# Node Version Manager
export NVM_DIR="/Users/wassim/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
