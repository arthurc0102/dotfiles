# Dotfiles

> My config files

## Install

1. Auto install: `curl -sL http://df.arthurc.me/setup.sh | sh`
2. Manual install:
   1. Clone this repo: `git clone https://github.com/arthurc0102/dotfiles ~/.dotfiles`.
   2. Run setup script: `sh ~/.dotfiles/setup.sh` or link config file to the right place by yourself.

## Setup

### Git

Update name and email in `~/.gitconfig.user`

If you need to use multi account add this to your `.gitconfig.user`

```conf
[includeIf "gitdir:~/Documents/projects/work/"]
  path = ~/.gitconfig.work
```

### Pipx

If you need pipx, run [setup-pipx.sh](./setup-pipx.sh).

## Test

- Test startup speed: `/usr/bin/time zsh -i -c exit`
