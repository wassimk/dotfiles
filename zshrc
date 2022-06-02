# Prompt
eval "$(starship init zsh)"

#
# Keys
#
# Enable emacs style editing keys
bindkey -e
bindkey "^[[1;3C" forward-word  # wordwise alt-right
bindkey "^[[1;3D" backward-word # wordwise alt-left
bindkey "^[[3~" delete-char     # delete current char

#
# Misc / Tools
#
# Edit current command with ctrl-x-x
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^x' edit-command-line

# adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Personal Aliases, Functions and Secrets
source $HOME/.zsh/completion
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.private

# Planning Center
eval "$($HOME/Code/pco/bin/pco init -)"
source $HOME/pco-box/env.sh
source $HOME/pco-box/bin/complete.bash

# Rust
if command -v cargo >/dev/null 2>&1; then
  source $HOME/.cargo/env
fi

# fzf auto-complete searching
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
case "$OSTYPE" in
  darwin*) [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh ;;
  linux*) source /usr/share/doc/fzf/examples/key-bindings.zsh ;
          source /usr/share/doc/fzf/examples/completion.zsh ;;
esac

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# loading this breaks most other completions
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-suggestions
source "$HOME"/.zsh/external/zsh-autosuggestions/zsh-autosuggestions.zsh

# ZSH Syntax Highlighting
case "$OSTYPE" in
  darwin*) source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
  linux*)  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
esac
