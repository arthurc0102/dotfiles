## Load antigen
source "$HOME/.antigen/bin/antigen.zsh"

## Load local config
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

## Setting before loading oh-my-zsh
zstyle :omz:plugins:ssh-agent identities $SSH_AGENT_IDENTITIES

## Load the oh-my-zsh's library.
antigen use oh-my-zsh

## Load plugins
antigen bundle git
antigen bundle ssh-agent
antigen bundle pip
antigen bundle docker
antigen bundle docker-compose
antigen bundle web-search
antigen bundle qoomon/zsh-lazyload
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zpm-zsh/clipboard

## Setup theme
source "$HOME/.dotfiles/zsh/theme.zsh"
antigen theme denysdovhan/spaceship-prompt

## Apply settings
antigen apply

## Load custom settings
source "$HOME/.dotfiles/zsh/alias.zsh"
source "$HOME/.dotfiles/zsh/config.zsh"
source "$HOME/.dotfiles/zsh/environments/android.zsh"
source "$HOME/.dotfiles/zsh/environments/flutter.zsh"
source "$HOME/.dotfiles/zsh/environments/gcloud.zsh"
source "$HOME/.dotfiles/zsh/environments/golang.zsh"
source "$HOME/.dotfiles/zsh/environments/mysql.zsh"
source "$HOME/.dotfiles/zsh/environments/node.zsh"
source "$HOME/.dotfiles/zsh/environments/python.zsh"

## Lazyload
lazyload pyenv python pip pipx -- 'load_pyenv'
lazyload nvm node npm npx git-cz -- 'load_nvm'
