#!/bin/sh

# Git pre-commit hook to check all staged Ruby (*.rb/haml/coffee) files
# for Pry binding references
#
# From https://gist.github.com/alexbevi/3436040
#
# Installation
#
#   ln -s ~/.dotfiles/bin/git-pre-commit-hook.sh /path/to/project/.git/hooks/pre-commit
#
# Based on
#
#   http://codeinthehole.com/writing/tips-for-using-a-git-pre-commit-hook/
#   http://mark-story.com/posts/view/using-git-commit-hooks-to-prevent-stupid-mistakes
#   https://gist.github.com/3266940

FILES='(js|css|rb)'
FORBIDDEN='(binding.pry|console.log|\!important)'
GREP_COLOR='4;5;37;41'

if [[ $(git diff --cached --name-only | grep -E $FILES) ]]; then
  git diff --cached --name-only | grep -E $FILES | \
  xargs grep --color --with-filename -n -E $FORBIDDEN && \
  echo "Looks like you are trying to commit something you shouldn't.  Please fix your diff, or run 'git commit --no-verify' to skip this check, if you must." && \
  exit 1
fi

exit 0
