## Load antigen
source "$HOME/.antigen/bin/antigen.zsh"

## Load the oh-my-zsh's library.
antigen use oh-my-zsh

## Load plugins
antigen bundle pip
antigen bundle docker
antigen bundle docker-compose
antigen bundle web-search
antigen bundle qoomon/zsh-lazyload
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

## Setup theme
source "$HOME/.dotfiles/zsh/theme.zsh"
antigen theme denysdovhan/spaceship-prompt

## Apply settings
antigen apply

## Load custom settings
source "$HOME/.dotfiles/zsh/alias.zsh"
source "$HOME/.dotfiles/zsh/config.zsh"
source "$HOME/.dotfiles/zsh/environmentals/android.zsh"
source "$HOME/.dotfiles/zsh/environmentals/flutter.zsh"
source "$HOME/.dotfiles/zsh/environmentals/mysql.zsh"
source "$HOME/.dotfiles/zsh/environmentals/golang.zsh"

lazyload pyenv python pip pipenv poetry -- 'source "$HOME/.dotfiles/zsh/environmentals/python.zsh"'
