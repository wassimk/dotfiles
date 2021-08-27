# always run gpg-agent
GPG_TTY=$(tty)
export GPG_TTY
case "$OSTYPE" in
  darwin*) gpg-agent --daemon --use-standard-socket &>/dev/null ;;
esac

# Load SSH keys stored in keychain
ssh-add -A 2>/dev/null
