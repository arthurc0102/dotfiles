# Dotfiles

> My config files

## Install

1. Clone this repo: `git clone https://github.com/arthurc0102/dotfiles.git ~/.dotfiles`.
2. Run setup script: `~/.dotfiles/setup.zsh` or link config file to the right place by yourself.

## Setup

### Git

Update name and email in [git config](./stow/dot-config/git/config)

If you need to use multi account, update [git config local](./stow-local/dot-config/git/config.local) create by [setup.zsh](./setup.zsh), see example below.

```conf
[includeIf "gitdir:~/projects/work/"]  # The trailing slash is necessary.
  path = ~/.config/git/config.work
```

Or you can create a new file in [git config local folder](./stow-local/dot-config/git/) like example below.

Example for `~/.dotfiles/stow-local/dot-config/git/config.work`

```conf
[core]
  sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/work.pub"

[user]
  email = work@example.com
  name = Your Name
```

And run [setup.zsh](./setup.zsh) again to link the config file to the right place.

### Python

Install with uv

```bash
uv python install <version>
```

### Node

Install with mise

```bash
mise use -g node@lts
```

### Homebrew

Dump brew list

```bash
brew bundle dump -f --file=Brewfile --no-vscode --no-go --no-cargo --no-uv --no-npm --no-describe
```

Install from Brewfile

```bash
brew bundle --file=Brewfile
```

## Test

- Test startup speed: `/usr/bin/time zsh -i -c exit`
