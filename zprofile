# Rust
if command -v cargo >/dev/null 2>&1; then
  source $HOME/.cargo/env
fi

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

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# loading this breaks most other completions
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loading this breaks

# Auto-suggestions
source "$HOME"/.zsh/external/zsh-autosuggestions/zsh-autosuggestions.zsh
