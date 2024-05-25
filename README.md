## dotfiles

These are config files and scripts to set up a system as I like it. They include configuration for `neovim`, `tmux`, `zsh`, `git`, and more.

I use macOS for most things, with an occasional stint working out of a cloud-hosted Linux machine.

#### Installation

Clone this repo and `cd` into it.

```shell
git clone git@github.com:wassimk/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

Install software & dotfiles:

```shell
./install.sh
```

That will install all of the software I use for development _(many of which these dotfiles rely on)_.

#### Maintenance

The [`install.sh`](install.sh) script can be rerun anytime since it updates installed software.

The [`dotfiles.sh`](dotfiles.sh) script can be rerun anytime to reload and add new dotfiles. It gets run at the end
of the install script. Also, it will prompt before it does anything destructive.

**Note:** If you copy this repository, you must change the gitconfig file to use your name, email, and commit signing key rather than mine.
