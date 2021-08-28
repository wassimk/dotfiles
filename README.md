# dotfiles

These are config files to set up a system the way I like it. It includes configuration for vim, tmux, zsh, git, and more.

I am running on macOS for side projects and Ubuntu for work.

## Installation

Clone this repo and `cd` into it.

```shell
git clone git@github.com:wassimk/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

Install software & dotfiles:

```shell
/bin/bash install.sh
```

That will install all of the key bits of software I use for development _(some of which these dotfiles rely on)_. 

## Maintenance

The `install.sh` script can be ran anytime to also update the same set of tools.

**Only reload the dotfiles**

``` bash
/bin/bash dotfiles.sh
```

It will prompt you before it does anything destructive.

**Note:** If you copy this repo please change the `gitconfig` file to use your name and email rather than mine.

