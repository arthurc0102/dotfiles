# Dotfiles

> My config files

## Install

1. Auto install: `curl -sL https://raw.githubusercontent.com/arthurc0102/dotfiles/master/setup.sh | sh`
2. Manual install:
    1. Clone this repo: `git clone https://github.com/arthurc0102/dotfiles.git ~/.dotfiles`.
    2. Run setup script: `sh ~/.dotfiles/setup.sh` or link config file to the right place by yourself.

## Setup

### Git

Update name and email in `~/.gitconfig.user`

If you need to use multi account add config below to your `.gitconfig.user`

```conf
[includeIf "gitdir:/path/to/work/"]  # The trailing slash is necessary.
  path = ~/.gitconfig.work
```

Example for `.gitconfig.work`

```conf
[core]
  sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/work.pub"

[user]
  email = work@example.com
  name = Your Name
```

### uv

Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### Nvm

Install nvm: `git clone https://github.com/nvm-sh/nvm.git ~/.nvm`

Install node:

```bash
nvm install --lts
nvm use --lts
```

### Font

Cascadia Code: <https://github.com/microsoft/cascadia-code>

Install with brew:

```bash
brew install --cask font-cascadia-mono-nf font-cascadia-code-nf
brew install --cask font-maple-mono-normal-nf-cn
```

## Test

- Test startup speed: `/usr/bin/time zsh -i -c exit`
