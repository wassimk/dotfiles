# Use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

# Load oh-my-zsh plugins, auto-completion, themes, etc.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="wassimk"
source $ZSH/oh-my-zsh.sh

# Add current directory bin
export PATH=$PATH:bin

# Add my own dotfiles bin
export PATH=$PATH:$HOME/.dotfiles/bin

# Sourcing of other files
source $HOME/.dotfiles/zsh/aliases
source $HOME/.dotfiles/zsh/functions
source $HOME/.bin/tmuxinator.zsh
source $HOME/.dotfiles/zsh/colors

# Node Version Manager
export NVM_DIR="/Users/wassim/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
