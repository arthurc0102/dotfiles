## Load antigen
source $HOME/.zsh/antigen/bin/antigen.zsh

## Load the oh-my-zsh's library.
antigen use oh-my-zsh

## Load plugins
antigen bundle pip
antigen bundle pyenv
antigen bundle docker
antigen bundle web-search
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

## Load theme config
source $HOME/.zsh/spaceshop-theme.zsh

## Set theme
antigen theme denysdovhan/spaceship-prompt

## Apply settings
antigen apply

## Load custom settings
source $HOME/.zsh/alias.zsh
source $HOME/.zsh/environmental.zsh  # This must be at the last of file.
