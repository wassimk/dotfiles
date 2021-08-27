# Use vim as the visual editor
export VISUAL='vim'
export EDITOR=$VISUAL

# Load oh-my-zsh plugins, auto-completion, themes, etc.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="wassimk"
plugins=()
source $ZSH/oh-my-zsh.sh

# Upgrade oh-my-zsh without asking
DISABLE_UPDATE_PROMPT=true

# Sourcing of other files
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.private

# fzf auto-complete searching
case "$OSTYPE" in
  darwin*) [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh ;;
  linux*) source /usr/share/doc/fzf/examples/key-bindings.zsh ;
          source /usr/share/doc/fzf/examples/completion.zsh ;;
esac

# ZSH Syntax Highlighting
case "$OSTYPE" in
  darwin*) source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
  linux*)  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
esac

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Planning Center
export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_READER_PORT_3306_TCP_PORT=3307
export PATH=$HOME/pco-box/bin:/usr/local/bin:$PATH
export RBENV_ROOT=$HOME/.rbenv
eval "$($HOME/Code/pco/bin/pco init -)"
eval "$(rbenv init -)"
