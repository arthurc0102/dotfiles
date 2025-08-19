## Variables

DOTFILES_HOME="${DOTFILES_HOME:-${HOME}/.dotfiles}"

## Install zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"


## Setup compinit for zinit

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


## Create cache and completions dir and add to $fpath (for oh-my-zsh plugins)

mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)


## Options

setopt interactivecomments  # Recognize comments


## Hooks

AUTO_PYTHON_VENV_NAME=".venv"

function activate-closest-python-venv() {
    if [[ -n "$AUTO_PYTHON_VENV_DISABLE" ]] || [[ -n "$POETRY_ACTIVE" ]]; then
        return
    fi

    # Only walk up the directory tree if one of the following is true:
    # - A venv is found in the current directory and it's not the current activated venv.
    # - No venv found before (AUTO_PYTHON_VENV_CURRENT_VENV_ROOT is not set).
    # - The current directory is not a subdirectory of the venv root.
    # - No activate script found in the venv root.
    if [[
        (-f "$PWD/$AUTO_PYTHON_VENV_NAME/bin/activate" && "$PWD/$AUTO_PYTHON_VENV_NAME" != "$VIRTUAL_ENV") ||
        -z "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT" ||
        "$PWD" != "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT"* ||
        ! -f "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT/$AUTO_PYTHON_VENV_NAME/bin/activate"
    ]]; then
        unset AUTO_PYTHON_VENV_CURRENT_VENV_ROOT  # Reset the venv root.

        local check="$PWD"
        while true; do
            if [[ -f "$check/$AUTO_PYTHON_VENV_NAME/bin/activate" ]]; then  # Stop if found venv.
                AUTO_PYTHON_VENV_CURRENT_VENV_ROOT="$check"
                break
            fi

            if [[ "$check" == "/" ]]; then  # Check until root directory (include root directory).
                break
            fi

            check=$(realpath "$check/..")
        done
    fi

    # If venv is not found, deactivate the venv (if any).
    if [[ -z "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT" ]]; then
        declare -f deactivate > /dev/null && deactivate
        return
    fi

    # If the founded venv is the current activated venv, do nothing.
    if [[ "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT/$AUTO_PYTHON_VENV_NAME" == "$VIRTUAL_ENV" ]]; then
        return
    fi

    # Deactivate the current venv (if any) and activate the found venv.
    declare -f deactivate > /dev/null && deactivate
    source "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT/$AUTO_PYTHON_VENV_NAME/bin/activate"
}

add-zsh-hook chpwd activate-closest-python-venv


function activate-closest-python-venv-on-start() {
    # Make sure activate-closest-python-venv only called once.
    [[ -n "$AUTO_PYTHON_VENV_ALREADY_CHECKED" ]] && return
    AUTO_PYTHON_VENV_ALREADY_CHECKED=1
    activate-closest-python-venv
}

# Add this hook to fixed venv is not activated when tmux open new pane.
add-zsh-hook precmd activate-closest-python-venv-on-start


## Key binding

bindkey ' ' magic-space
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward


## History

HISTSIZE=50000
SAVEHIST=50000

setopt inc_append_history


## Load oh-my-zsh stuff

zinit for \
    OMZL::history.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZL::completion.zsh

# Load brew shellenv to avoid path order issue in tmux.
#   `eval "$(brew shellenv)"` this command add brew's bin to PATH, move it to the front
#   if it's already in PATH.
#
# Don't use `has'brew'` because this plugin will found brew install location and
#   add it to PATH.
zinit for \
    atload'command -v brew >/dev/null && eval "$(brew shellenv)"' \
        OMZP::brew

zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    \
    OMZP::cp \
    OMZP::git \
    OMZP::jump

zinit wait lucid as'completion' for \
    OMZP::pip/_pip \
    OMZP::docker-compose/_docker-compose


## Load other plugins

zinit wait lucid for \
    blockf \
    atpull'
        zinit creinstall -q .
    ' \
        zsh-users/zsh-completions

# Remap Ctrl+r for Alt+r for joshskidmore/zsh-fzf-history-search
zinit wait lucid for \
    atload'
        export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS="--layout=reverse --height 40% --cycle --border=none"
    ' \
    bindmap'^r -> ^[r' \
        joshskidmore/zsh-fzf-history-search

zinit wait lucid for \
    as'command' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/git-open $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/git-open' \
        https://github.com/paulirish/git-open/blob/master/git-open

# Use this plugin because oh-my-zsh's nvm plugin has a problem with completion.
# The completion will be handled by zsh-completions plugin.
# Zinit will handle the lazy load part.
zinit wait lucid for \
    lukechilds/zsh-nvm

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    mv'delta* -> delta' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/delta/delta $ZPFX/bin
        $PWD/delta/delta --generate-completion zsh > delta/_delta
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/delta' \
        dandavison/delta

# Key bindings docs: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
# CTRL-T - Paste the selected files and directories onto the command-line
# ALT-C - cd into the selected directory
#
# Config:
# - Disable CTRL-T.
# - Remove CTRL-R when atload, use ALT-R for fzf history search.
zinit wait lucid for \
    as'program' \
    from'gh-r' \
    atinit'
        FZF_CTRL_T_COMMAND=""
    ' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/fzf $ZPFX/bin
        $PWD/fzf --zsh > integration.zsh
    ' \
    atpull'%atclone' \
    atload'
        export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --color always --exclude .git"
        export FZF_DEFAULT_OPTS="--height 40% --tmux center --layout reverse --border --ansi"
        export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
        export FZF_ALT_C_OPTS="--preview \"tree -C {}\" --tmux center,70%,50%"

        bindkey "^r" history-incremental-pattern-search-backward
    ' \
    src'integration.zsh' \
    pick'$ZPFX/bin/fzf' \
        junegunn/fzf

zinit wait lucid for \
    as'program' \
    id-as'fzf-preview.sh' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/fzf-preview.sh $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/fzf-preview.sh' \
        https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/bin/fzf-preview.sh

zinit wait lucid for \
    id-as'fzf-git.sh' \
        https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    mv'ripgrep* -> ripgrep' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/ripgrep/rg $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/rg' \
        BurntSushi/ripgrep

# Add `@` to the name to avoid zinit to treat it as a command.
# Docs: https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/#a_few_remarks
zinit wait lucid for \
    as'program' \
    from'gh-r' \
    mv'bat* -> bat' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/bat/bat $ZPFX/bin
        cp bat/autocomplete/bat.zsh bat/_bat
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/bat' \
        @sharkdp/bat

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    mv'fd* -> fd' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/fd/fd $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/fd' \
        @sharkdp/fd

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    mv'xh* -> xh' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/xh/xh $ZPFX/bin
    ' \
    atpull'%atclone' \
    atload'
        alias http="xh"
        alias https="xh --https"
    ' \
    pick'$ZPFX/bin/xh' \
        ducaale/xh

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/lazygit $ZPFX/bin

        (
            if [[ "$(uname)" == "Darwin" ]]; then
                lazygit_dir="${HOME}/Library/Application Support/lazygit"
            else
                lazygit_dir="${HOME}/.config/lazygit"
            fi

            mkdir -p "${lazygit_dir}"
            ln -svf ${DOTFILES_HOME}/lazygit/config.yml "${lazygit_dir}/config.yml"
        )
    ' \
    atpull'%atclone' \
    atload'
        lg() {
            export LAZYGIT_NEW_DIR_FILE=/tmp/lazygit_newdir

            lazygit "$@"

            if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
                cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
                rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
            fi

            unset LAZYGIT_NEW_DIR_FILE
        }
    ' \
    pick'$ZPFX/bin/lazygit' \
        jesseduffield/lazygit

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/lazydocker $ZPFX/bin
    ' \
    atpull'%atclone' \
    atload'
        alias lc="lazydocker"
    ' \
    pick'$ZPFX/bin/lazydocker' \
        jesseduffield/lazydocker

zinit wait lucid for \
    as'program' \
    from'gh-r' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/zellij $ZPFX/bin
        ./zellij setup --generate-completion zsh > _zellij

        ln -svf ${DOTFILES_HOME}/zellij/config.kdl ${HOME}/.config/zellij/config.kdl
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/zellij' \
        zellij-org/zellij


## Load local stuff

zinit is-snippet link for \
    ${DOTFILES_HOME}/zsh/custom/golang.zsh

zinit wait lucid is-snippet link for \
    ${DOTFILES_HOME}/zsh/custom/alias.zsh \
    ${DOTFILES_HOME}/zsh/custom/config.zsh \
    has'terraform' \
        ${DOTFILES_HOME}/zsh/custom/terraform.zsh


## Setup completions

zinit wait lucid \
    as'completion' \
    atpull'%atclone' \
    run-atpull \
    blockf \
    nocompile \
    for \
        has'docker' \
        id-as'docker-completion' \
        atclone'docker completion zsh > _docker' \
            zdharma-continuum/null \
        has'poetry' \
        id-as'poetry-completion' \
        atclone'poetry completions zsh > _poetry' \
            zdharma-continuum/null \
        has'uv' \
        id-as'uv-completion' \
        atclone'uv generate-shell-completion zsh > _uv' \
            zdharma-continuum/null \
        has'op' \
        id-as'1password-completion' \
        atclone'op completion zsh > _op' \
            zdharma-continuum/null \
        has'cz' \
        id-as'cz-completion' \
        atclone'$(dirname $(realpath $(which cz)))/register-python-argcomplete cz > _cz' \
            zdharma-continuum/null


## Special order plugins

# Fast syntax should be second to last plugin to work normally.
zinit wait lucid for \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
        zdharma-continuum/fast-syntax-highlighting

# This should be the last plugin to load to avoid auto select suggestions when tab is pressed.
zinit wait lucid for \
    atload'!_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions


## Load theme

zinit ice \
    as'command' \
    from'gh-r' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/starship $ZPFX/bin
        ./starship init zsh > init.zsh
        ./starship completions zsh > _starship
    ' \
    atpull'%atclone' \
    atload'
        export VIRTUAL_ENV_DISABLE_PROMPT=true
        export STARSHIP_CONFIG=${DOTFILES_HOME}/zsh/theme/starship.toml
    ' \
    src'init.zsh' \
    pick'$ZPFX/bin/starship'

zinit light starship/starship

# Set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
