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
# Hooks
#
autoload -U add-zsh-hook

function -auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ll
  fi
}
add-zsh-hook chpwd -auto-ls-after-cd

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
