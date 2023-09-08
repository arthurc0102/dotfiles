# Intall zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"


# Setup compinit for zinit

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Create cache and completions dir and add to $fpath (for oh-my-zsh plugins)

mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)


# Options

setopt interactivecomments  # recognize comments


# Key binding

bindkey ' ' magic-space
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward


# Load oh-my-zsh stuff

zinit for \
    OMZL::history.zsh

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
    OMZP::brew \
    OMZP::nvm

zinit wait lucid as"completion" for \
    OMZP::pip/_pip \
    OMZP::docker-compose/_docker-compose \
    OMZP::nvm/_nvm


# Load other plugins

# Remap Ctrl+r for Alt+r for zdharma-continuum/history-search-multi-word
zinit wait lucid for \
    blockf atpull"zinit creinstall -q ." \
        zsh-users/zsh-completions \
    bindmap'^R -> ^[r' \
        zdharma-continuum/history-search-multi-word \
    as"command" \
        https://github.com/paulirish/git-open/blob/master/git-open

# 用這個 completion 才能補全 image 或 container 名稱，用 Oh-My-Zsh Plugin 所產的沒辦法
zinit wait lucid as"completion" for \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zinit wait lucid for \
    id-as'poetry-completion' \
    as'completion' \
    atclone'poetry completions zsh > _poetry' \
    atpull'%atclone' \
    blockf \
    has'poetry' \
    nocompile \
        zdharma-continuum/null

zinit wait lucid as"program" from"gh-r" for \
    mv"delta* -> delta" \
    atclone"mkdir -p bin; mv delta/delta bin" \
    atpull"%atclone" \
    pick"bin/delta" \
        dandavison/delta

# Load custom

zinit wait lucid is-snippet for \
    ${HOME}/.dotfiles/zsh/custom/alias.zsh \
    ${HOME}/.dotfiles/zsh/custom/config.zsh \
    ${HOME}/.dotfiles/zsh/custom/golang.zsh \
    atload"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        ${HOME}/.dotfiles/zsh/custom/python.zsh


# Load autosuggestions (這個必須要是最後一個載入的 plugin 才不會造成 tab 按下後自動選取 autosuggestions 的內容)
# Fast syntax highlighting 也需要在最後才會正常顯示顏色

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions


# Load themes

zinit ice \
    as"command" \
    from"gh-r" \
    atclone"mkdir -p bin; mv starship bin; bin/starship init zsh > init.zsh; bin/starship completions zsh > _starship" \
    atpull"%atclone" \
    src"init.zsh" \
    pick"bin/starship"

export VIRTUAL_ENV_DISABLE_PROMPT=true  # Starship will control venv prompt.
export STARSHIP_CONFIG=${HOME}/.dotfiles/zsh/theme/starship.toml
zinit light starship/starship
