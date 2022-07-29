#!/bin/sh
#
# Installation
#
#   ln -s ~/.bin/git-pre-commit-hook.sh /path/to/project/.git/hooks/pre-commit

# Check all staged Ruby (*.rb/haml/coffee) files
# for Pry binding references
# https://gist.github.com/alexbevi/3436040

FILES='(js|css|rb)'
FORBIDDEN='(binding.pry|console.log|\!important)'
GREP_COLOR='4;5;37;41'

if [[ $(git diff --cached --name-only | grep -E $FILES) ]]; then
  git diff --cached --name-only | grep -E $FILES | \
  xargs grep --color --with-filename -n -E $FORBIDDEN && \
  echo "Looks like you are trying to commit something you shouldn't.  Please fix your diff, or run 'git commit --no-verify' to skip this check, if you must." && \
  exit 1
fi

# Get this far then nothing failed so exit clean
exit 0
