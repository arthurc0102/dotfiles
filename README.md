# Dotfiles

> My config files

## Install

1. Clone this repo: `git clone https://github.com/arthurc0102/dotfiles.git ~/.dotfiles`.
2. Run setup script: `~/.dotfiles/setup.zsh` or link config file to the right place by yourself.

## Setup

### Git

Update name and email in [git config](./stow/dot-config/git/config)

If you need to use multi account add config below to git config file or `~/.config/git/config.local` create by [setup.zsh](./setup.zsh)

```conf
[includeIf "gitdir:~/projects/work/"]  # The trailing slash is necessary.
  path = ~/.config/git/config.work
```

Example for `~/.config/git/config.work`

```conf
[core]
  sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/work.pub"

[user]
  email = work@example.com
  name = Your Name
```

### uv

Install uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`

### NVM

Install NVM: `git clone https://github.com/nvm-sh/nvm.git ~/.nvm`

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
