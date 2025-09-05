## Variables

DOTFILES_HOME="${DOTFILES_HOME:-${HOME}/.dotfiles}"

## Install zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname ${ZINIT_HOME})"
[ ! -d $ZINIT_HOME/.git ] && git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"

source "${ZINIT_HOME}/zinit.zsh"


## Create cache and completions dir and add to $fpath (for oh-my-zsh plugins)

mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)$ZSH_CACHE_DIR/completions]} )) || zinit add-fpath --front "$ZSH_CACHE_DIR/completions"


## Options

setopt interactivecomments  # Recognize comments



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
    OMZL::completion.zsh \
    OMZL::functions.zsh \
    atload'
        # Set title to the current directory, without username and hostname.
        ZSH_THEME_TERM_TITLE_IDLE="%~"
    ' \
        OMZL::termsupport.zsh \
    atload'
        # Run `eval "$(brew shellenv)"` in tmux to move it to the front of PATH, so command from brew will be default (ex. git).
        if [[ -n $TMUX ]] && command -v brew > /dev/null; then
            eval "$(brew shellenv)"
        fi
    ' \
        OMZP::brew

zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    \
    OMZP::cp \
    OMZP::git \
    atload'
        alias j='jump'     # Jump to a directory
        alias jc='mark'    # Mark the current directory
        alias jd='unmark'  # Unmark the current directory
        alias jl='marks'   # List all marks
    ' \
        OMZP::jump \
    atinit'
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    ' \
    atload'
        nvm_latest_tag() {
            if [[ ! -d "$NVM_DIR" ]]; then
                echo "NVM is not installed, run \"nvm_install\" to install"
                return
            fi

            echo $(builtin cd "$NVM_DIR" && git fetch --quiet --tags origin && git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
        }

        nvm_install() {
            echo "Installing NVM..."
            git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
            $(builtin cd "$NVM_DIR" && git checkout --quiet "$(nvm_latest_tag)")
        }

        nvm_upgrade() {
            local installed_version=$(builtin cd "$NVM_DIR" && git describe --tags)
            echo "Current NVM version is $installed_version"

            echo "Checking latest version of NVM..."
            local latest_version=$(nvm_latest_tag)

            if [[ "$installed_version" = "$latest_version" ]]; then
                echo "NVM is already up to date"
            else
                echo "Updating NVM to $latest_version..."
                $(builtin cd "$NVM_DIR" && git fetch --quiet && git checkout "$latest_version")
            fi
        }
    ' \
        OMZP::nvm

zinit wait lucid as'completion' blockf for \
    OMZP::terraform/_terraform


## Load other plugins

# Remap Ctrl+r for Alt+r for joshskidmore/zsh-fzf-history-search
zinit wait lucid for \
    depth'1' \
    atload'
        export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS="--layout=reverse --height 40% --cycle --border=none"
    ' \
    bindmap'^r -> ^[r' \
        joshskidmore/zsh-fzf-history-search

zinit wait lucid for \
    as'program' \
    depth'1' \
    cloneopts'--no-recurse-submodules' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/git-open $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/git-open' \
        paulirish/git-open

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

        alias fzf-finder="
            FZF_DEFAULT_COMMAND=\"$FZF_DEFAULT_COMMAND --type f\" \
            fzf \
                --style full \
                --height 100% \
                --preview \"fzf-preview.sh {}\" \
                --bind \"ctrl-u:preview-up,ctrl-d:preview-down,enter:become(realpath {})\"
        "
    ' \
    src'integration.zsh' \
    pick'$ZPFX/bin/fzf' \
        junegunn/fzf

zinit wait lucid for \
    id-as'junegunn---fzf-preview.sh' \
    as'program' \
    mv'junegunn---fzf-preview.sh -> fzf-preview.sh' \
    atclone'
        mkdir -p $ZPFX/bin
        ln -svf $PWD/fzf-preview.sh $ZPFX/bin
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/fzf-preview.sh' \
        https://github.com/junegunn/fzf/blob/master/bin/fzf-preview.sh

zinit wait lucid for \
    id-as'junegunn---fzf-git.sh' \
        https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh

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

zinit wait lucid is-snippet link for \
    id-as'_local---alias' \
        ${DOTFILES_HOME}/zsh/custom/alias.zsh \
    id-as'_local---auto-python-venv' \
        ${DOTFILES_HOME}/zsh/custom/auto-python-venv.zsh

## Setup completions

zinit wait lucid \
    as'completion' \
    depth'1' \
    atpull'%atclone' \
    run-atpull \
    blockf \
    nocompile \
    for \
        has'docker' \
        id-as'_local---docker-completion' \
        atclone'docker completion zsh > _docker' \
            zdharma-continuum/null \
        has'poetry' \
        id-as'_local---poetry-completion' \
        atclone'poetry completions zsh > _poetry' \
            zdharma-continuum/null \
        has'uv' \
        id-as'_local---uv-completion' \
        atclone'uv generate-shell-completion zsh > _uv' \
            zdharma-continuum/null \
        has'uvx' \
        id-as'_local---ruff-completion' \
        atclone'uvx ruff generate-shell-completion zsh > _ruff' \
            zdharma-continuum/null \
        has'op' \
        id-as'_local---1password-completion' \
        atclone'op completion zsh > _op' \
            zdharma-continuum/null \
        has'cz' \
        id-as'_local---cz-completion' \
        atclone'$(dirname $(realpath $(which cz)))/register-python-argcomplete cz > _cz' \
            zdharma-continuum/null


## Special order plugins

# Fast syntax should be second to last plugin to work normally.
zinit wait lucid for \
    depth'1' \
    atinit'ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay' \
        zdharma-continuum/fast-syntax-highlighting

# This should be the last plugin to load to avoid auto select suggestions when tab is pressed.
zinit wait lucid for \
    depth'1' \
    atload'!_zsh_autosuggest_start' \
        zsh-users/zsh-autosuggestions


## Load theme

zinit ice \
    as'program' \
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
