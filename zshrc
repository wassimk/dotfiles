# Prompt
eval "$(starship init zsh)"

#
# Keys
#
# Enable emacs style editing keys
bindkey -e

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

# asdf
source $HOME/.asdf/asdf.sh

# Personal Aliases, Functions and Secrets
source $HOME/.zsh/completion
source $HOME/.zsh/aliases
source $HOME/.zsh/functions
source $HOME/.private
 
# fzf auto-complete searching
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
case "$OSTYPE" in
  darwin*) [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh ;;
  linux*) source /usr/share/doc/fzf/examples/key-bindings.zsh ;
          source /usr/share/doc/fzf/examples/completion.zsh ;;
esac

# Rust
[ -f "$HOME"/.cargo/env ] && source "$HOME"/.cargo/env

# Zoxide
eval "$(zoxide init zsh --cmd cd)"

# Auto-suggestions
case "$OSTYPE" in
  darwin*) source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ;;
  linux*)  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ;;
esac

# ZSH Syntax Highlighting
case "$OSTYPE" in
  darwin*) source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
  linux*)  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
esac

# always be in tmux, except when vscode
[[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Apple_Terminal" ]] && ensure_tmux_is_running

# 1password cli
source $HOME/.config/op/plugins.sh

# gpg signing
export GPG_TTY=$(tty)

# Planning Center
eval "$($HOME/Code/pco/bin/pco init -)"
source $HOME/pco-box/env.sh
source $HOME/pco-box/bin/complete.bash

if [[ -e "/opt/homebrew/bin/brew" ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -d $HOME/.rbenv ]]; then
  eval "$(rbenv init -)"
fi

if [[ -d "$HOME/.asdf" ]]; then
  source "$HOME/.asdf/asdf.sh"
fi

if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi
