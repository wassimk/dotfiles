# always run gpg-agent
GPG_TTY=$(tty)
export GPG_TTY
case "$OSTYPE" in
  darwin*) gpg-agent --daemon --use-standard-socket &>/dev/null ;;
esac
