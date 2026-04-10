#!/bin/bash

set -e

echo "Resetting Rails JS..."

rm -rf node_modules

# Detect JS bundler from Gemfile to pick the right clobber task
clobber_task=""
if [ -f Gemfile ]; then
  if grep -qE "^\s*gem ['\"]shakapacker['\"]" Gemfile; then
    clobber_task="shakapacker:clobber"
  elif grep -qE "^\s*gem ['\"]vite_rails['\"]" Gemfile || grep -qE "^\s*gem ['\"]vite_ruby['\"]" Gemfile; then
    clobber_task="vite:clobber"
  elif grep -qE "^\s*gem ['\"]webpacker['\"]" Gemfile; then
    clobber_task="webpacker:clobber"
  fi
fi

if [ -n "$clobber_task" ]; then
  bundle exec rake assets:clobber tmp:clear "$clobber_task"
else
  echo "Warning: no JS bundler gem detected in Gemfile, skipping bundler clobber"
  bundle exec rake assets:clobber tmp:clear
fi

touch tmp/restart.txt
yarn install
touch tmp/restart.txt
