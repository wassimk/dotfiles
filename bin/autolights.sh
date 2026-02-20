#!/bin/bash

# Save this somewhere convenient, like your dotfiles or custom scripts folder.
# Update it with your light(s) IP address.

# Begin looking at the system log via the steam sub-command. Using a --predicate and filtering by the correct and pull out the camera event
log stream --predicate 'subsystem == "com.apple.UVCExtension" and composedMessage contains "Post PowerLog"' | while read -r line; do

  # The camera start event has been caught and is set to 'On', turn the light on
  if echo "$line" | grep -q "= On"; then

	echo "Camera has been activated, turn on the light."

  "$HOME"/Library/Application\ Support/com.raycast.macos/extensions/elgato-light-controller/cli/elgato-light on --brightness 10 --temperature 5000

  fi

  # If we catch a camera stop event, turn the light off.
  if echo "$line" | grep -q "= Off"; then
	echo "Camera shut down, turn off the light."

  "$HOME"/Library/Application\ Support/com.raycast.macos/extensions/elgato-light-controller/cli/elgato-light off
  fi
done
