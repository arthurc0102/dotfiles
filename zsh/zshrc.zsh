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
    OMZL::clipboard.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::key-bindings.zsh \
    OMZL::theme-and-appearance.zsh

zinit wait lucid for \
    OMZP::cp \
    OMZP::git \
    OMZP::pip \
    OMZP::pyenv \
    OMZP::poetry \
    OMZP::brew \
    OMZP::nvm

zinit as"completion" for \
    OMZP::pip/_pip \
    OMZP::docker-compose/_docker-compose


# Load other plugins

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

zinit wait lucid for \
    zdharma-continuum/history-search-multi-word


# Load themes

source ${HOME}/.dotfiles/zsh/theme/*.zsh
zinit light spaceship-prompt/spaceship-prompt


# Load custom

source ${HOME}/.dotfiles/zsh/custom/*.zsh
