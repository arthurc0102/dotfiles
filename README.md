# Dotfiles

> My config files

## Install

1. Auto install: `curl -sL http://df.arthurc.me/setup.sh | sh`
2. Manual install:
   1. Clone this repo: `git clone --recursive https://github.com/arthurc0102/dotfiles.git ~/.dotfiles`.
   2. Run setup script: `sh ~/.dotfiles/setup.sh` or link config file to the right place by yourself.

## Setup

### Git

Update name and email in `~/.gitconfig.user`

If you need to use multi account add this to your `.gitconfig.user`

```conf
[includeIf "gitdir:~/Documents/projects/work/"]
  path = ~/.gitconfig.work
```

### Pyenv

Install pyenv: `git clone git://github.com/pyenv/pyenv.git ~/.pyenv`

Install python:

```bash
pyenv install 3.9.1  # Or other version
pyenv global 3.9.1  # Or other version
```

### Pipx

> Make sure you have Python3 already.

If you need pipx, run [setup-pipx.sh](./setup-pipx.sh).
Install `argcomplete` for pipx autocomplete: `pipx install argcomplete`.

### Nvm

Install nvm: `git clone git://github.com/nvm-sh/nvm.git ~.nvm`

Install node:

```bash
nvm install --lts
nvm use --lts
```

## Test

- Test startup speed: `/usr/bin/time zsh -i -c exit`
