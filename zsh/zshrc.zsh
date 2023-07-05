# Intall zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"


# Setup compinit for zinit

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Load oh-my-zsh stuff

zinit for \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh

zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZL::completion.zsh

zinit wait lucid for \
    OMZP::cp \
    OMZP::git \
    OMZP::pip \
    OMZP::pyenv \
    OMZP::poetry \
    OMZP::brew \
    OMZP::nvm

zinit wait lucid as"completion" for \
    OMZP::pip/_pip \
    OMZP::docker-compose/_docker-compose \
    OMZP::nvm/_nvm


# Load other plugins

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

zinit wait lucid for \
    zdharma-continuum/history-search-multi-word \
    paulirish/git-open


# Load themes

source ${HOME}/.dotfiles/zsh/theme/spaceship.zsh
zinit light spaceship-prompt/spaceship-prompt


# Load custom

zinit wait lucid is-snippet for \
    ${HOME}/.dotfiles/zsh/custom/alias.zsh \
    ${HOME}/.dotfiles/zsh/custom/config.zsh \
    ${HOME}/.dotfiles/zsh/custom/golang.zsh \
    atload"zicompinit; zicdreplay" \
        ${HOME}/.dotfiles/zsh/custom/python.zsh
