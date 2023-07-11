# Intall zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"


# Setup compinit for zinit

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Create cache and completions dir and add to $fpath

mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)


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
    blockf atpull"zinit creinstall -q ." \
        zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word \
    paulirish/git-open

zinit wait lucid as"completion" for \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker


# Load custom

zinit wait lucid is-snippet for \
    ${HOME}/.dotfiles/zsh/custom/alias.zsh \
    ${HOME}/.dotfiles/zsh/custom/config.zsh \
    ${HOME}/.dotfiles/zsh/custom/golang.zsh \
    atload"zicompinit; zicdreplay" \
        ${HOME}/.dotfiles/zsh/custom/python.zsh


# Load autosuggestions (這個必須要是最後一個載入的 plugin 才不會造成 tab 按下後自動選取 autosuggestions 的內容)

zinit wait lucid for \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions


# Load themes

zinit ice \
    as"command" \
    from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" \
    src"init.zsh"

export VIRTUAL_ENV_DISABLE_PROMPT=true  # Starship will control venv prompt.
export STARSHIP_CONFIG=${HOME}/.dotfiles/zsh/theme/starship.toml
zinit light starship/starship
