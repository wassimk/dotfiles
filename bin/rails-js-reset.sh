#!/bin/bash

echo "Resetting Rails JS..."

rm -rf node_modules
bundle exec rake assets:clobber tmp:clear webpacker:clobber
touch tmp/restart.txt
yarn install
touch tmp/restart.txt
