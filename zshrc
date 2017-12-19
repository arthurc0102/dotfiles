## Load antigen
source $HOME/.zsh/antigen/bin/antigen.zsh

## Load the oh-my-zsh's library.
antigen use oh-my-zsh

## Load plugins
antigen bundle pip
antigen bundle web-search
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

## Powerlevel9k theme settings
# POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
# POWERLEVEL9K_MODE='awesome-patched'
# POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
# POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv ssh context dir rbenv vcs dir_writable)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
# antigen theme bhilburn/powerlevel9k powerlevel9k

## Pure theme settings
# PURE_PROMPT_SYMBOL='➜ '
# antigen bundle mafredri/zsh-async
# antigen bundle marszall87/lambda-pure

## Arch theme settings
# source $HOME/.zsh/arch-zsh-theme

## Robbyrussell theme settings
# antigen theme robbyrussell

## Sobole theme settings
# antigen theme sobolevn/sobole-zsh-theme

## spaceship theme settings - mode A
# SPACESHIP_PROMPT_SYMBOL='➜ '
# SPACESHIP_VENV_PREFIX='('
# SPACESHIP_VENV_SUFFIX=') '
# SPACESHIP_DIR_TRUNC='0'
# SPACESHIP_GIT_SYMBOL=':'
# SPACESHIP_GIT_PREFIX='git'
# SPACESHIP_DIR_PREFIX=' '
# SPACESHIP_PROMPT_ORDER=(dir git line_sep venv char)
# antigen theme denysdovhan/spaceship-zsh-theme

## spaceship theme settings - mode B
SPACESHIP_PROMPT_ADD_NEWLINE='false'
SPACESHIP_DIR_TRUNC='0'
SPACESHIP_DIR_PREFIX=' '
SPACESHIP_GIT_PREFIX='on'
SPACESHIP_GIT_SYMBOL=' '
SPACESHIP_VENV_PREFIX='using '
SPACESHIP_VENV_COLOR='magenta'
SPACESHIP_PROMPT_SYMBOL='➜ '
SPACESHIP_PROMPT_ORDER=(dir venv git char)
antigen theme denysdovhan/spaceship-zsh-theme

## Apply settings
antigen apply

## Load custom settings
source $HOME/.zsh/alias
source $HOME/.zsh/environmental
