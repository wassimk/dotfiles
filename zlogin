# always run gpg-agent
case "$OSTYPE" in
  darwin*) gpg-agent --daemon &>/dev/null ;;
esac

# Load SSH keys stored in keychain
ssh-add -A 2>/dev/null

# Bash-style word splitting and globbing for Claude Code, which writes bash idioms
# (lives here because its Bash tool runs `zsh -c -l`, which skips zshrc)
if [[ -n "$CLAUDECODE" ]]; then
  setopt sh_word_split no_nomatch ksh_arrays bash_rematch
fi
