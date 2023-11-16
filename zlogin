# always run gpg-agent
case "$OSTYPE" in
  darwin*) gpg-agent --daemon &>/dev/null ;;
esac

# Load SSH keys stored in keychain
ssh-add -A 2>/dev/null
