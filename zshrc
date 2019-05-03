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

## Arch theme settings
# source $HOME/.zsh/arch-zsh-theme.zsh

## spaceship theme settings - mode A
SPACESHIP_CHAR_SYMBOL='❯ '
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=') '
SPACESHIP_VENV_COLOR='magenta'
SPACESHIP_DIR_PREFIX=' '
SPACESHIP_DIR_TRUNC='0'
SPACESHIP_DIR_TRUNC_REPO='false'
SPACESHIP_GIT_SYMBOL=':'
SPACESHIP_GIT_PREFIX='git'
SPACESHIP_PROMPT_ORDER=(dir git line_sep venv char)
antigen theme denysdovhan/spaceship-zsh-theme

## spaceship theme settings - mode B
# SPACESHIP_PROMPT_ADD_NEWLINE='false'
# SPACESHIP_DIR_PREFIX=' '
# SPACESHIP_DIR_TRUNC='0'
# SPACESHIP_DIR_TRUNC_REPO='false'
# SPACESHIP_GIT_PREFIX='on'
# SPACESHIP_GIT_SYMBOL=' '
# SPACESHIP_VENV_PREFIX='using '
# SPACESHIP_VENV_COLOR='magenta'
# SPACESHIP_CHAR_SYMBOL='$ '
# SPACESHIP_PROMPT_ORDER=(user host dir venv git char)
# antigen theme denysdovhan/spaceship-zsh-theme

## Apply settings
antigen apply

## Load custom settings
source $HOME/.zsh/alias.zsh
source $HOME/.zsh/environmental.zsh  # This must be at the last of file.
