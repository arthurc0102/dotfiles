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


# Hooks

function activate-closest-python-venv() {
    if [ -n "$DISABLE_AUTO_VENV" ] || [ -n "$POETRY_ACTIVE" ]; then
        return
    fi

    declare -f deactivate > /dev/null && deactivate

    check="$PWD"
    while [ "$check" != $(realpath "$HOME/..") ]; do  # Check until home directory
        [ -f "$check/.venv/bin/activate" ] && source "$check/.venv/bin/activate" && return
        check=$(realpath "$check/..")
    done
}

add-zsh-hook chpwd activate-closest-python-venv


# Key binding

bindkey ' ' magic-space
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward


# History

HISTSIZE=50000
SAVEHIST=50000

setopt inc_append_history


# Load oh-my-zsh stuff

zinit for \
    OMZL::history.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZL::completion.zsh

# Load brew shellenv after load, to avoid path order issue in tmux.
# `eval "$(brew shellenv)"` this command add brew's bin to PATH, move it to the front if it's already in PATH.
zinit for \
    atload'command -v brew >/dev/null && eval "$(brew shellenv)"' \
        OMZP::brew

zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::directories.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh

zinit wait lucid for \
    OMZP::cp \
    OMZP::git \
    OMZP::jump

zinit wait lucid as"completion" for \
    OMZP::pip/_pip \
    OMZP::docker-compose/_docker-compose


# Load other plugins

# Remap Ctrl+r for Alt+r for joshskidmore/zsh-fzf-history-search
zinit wait lucid for \
    blockf atpull"zinit creinstall -q ." \
        zsh-users/zsh-completions \
    bindmap'^r -> ^[r' \
    atload'export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS="--layout=reverse --height 40% --cycle --border=none"' \
        joshskidmore/zsh-fzf-history-search \
    as"command" \
    atclone'mkdir -p $ZPFX/bin; ln -svf $PWD/git-open $ZPFX/bin' \
    atpull"%atclone" \
    pick'$ZPFX/bin/git-open' \
        https://github.com/paulirish/git-open/blob/master/git-open

# 改用這個套件因為 oh-my-zsh 的補全有問題，補全的部份吃 zsh-completions 中的，lazy load 的部分讓 zinit 處理
zinit wait lucid for \
    lukechilds/zsh-nvm

zinit wait lucid for \
    id-as'docker-completion' \
    as'completion' \
    atclone'docker completion zsh > _docker' \
    atpull'%atclone' \
    blockf \
    has'docker' \
    nocompile \
        zdharma-continuum/null

zinit wait lucid for \
    id-as'poetry-completion' \
    as'completion' \
    atclone'poetry completions zsh > _poetry' \
    atpull'%atclone' \
    blockf \
    has'poetry' \
    nocompile \
        zdharma-continuum/null

zinit wait lucid for \
    id-as'uv-completion' \
    as'completion' \
    atclone'uv generate-shell-completion zsh > _uv' \
    atpull'%atclone' \
    blockf \
    has'uv' \
    nocompile \
        zdharma-continuum/null

zinit wait lucid for \
    id-as'1password-completion' \
    as'completion' \
    atclone'op completion zsh > _op' \
    atpull'%atclone' \
    blockf \
    has'op' \
    nocompile \
        zdharma-continuum/null

zinit wait lucid for \
    as"program" \
    from"gh-r" \
    mv"delta* -> delta" \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/delta/delta $ZPFX/bin;
        $PWD/delta/delta --generate-completion zsh > delta/_delta;
    ' \
    atpull"%atclone" \
    pick'$ZPFX/bin/delta' \
        dandavison/delta

# Keybind Docs: https://github.com/junegunn/fzf?tab=readme-ov-file#key-bindings-for-command-line
# CTRL-T - Paste the selected files and directories onto the command-line
# ALT-C - cd into the selected directory
#
# Config:
# - Disable CTRL-T.
# - Remove CTRL-R when atload, use ALT-R for fzf history search.
zinit wait lucid for \
    as"program" \
    from"gh-r" \
    atinit'
        FZF_CTRL_T_COMMAND="";
    ' \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/fzf $ZPFX/bin;
        $PWD/fzf --zsh > integration.zsh;
    ' \
    atpull'%atclone' \
    atload'
        export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --color always --exclude .git";
        export FZF_DEFAULT_OPTS="--height 40% --tmux center --layout reverse --border --ansi";
        export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d";
        export FZF_ALT_C_OPTS="--preview \"tree -C {}\" --tmux center,70%,50%";
        bindkey "^r" history-incremental-pattern-search-backward;
    ' \
    src'integration.zsh' \
    pick'$ZPFX/bin/fzf' \
        junegunn/fzf

zinit wait lucid for \
    as"program" \
    id-as'fzf-preview.sh' \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/fzf-preview.sh $ZPFX/bin;
    ' \
    atpull'%atclone' \
    pick'$ZPFX/bin/fzf-preview.sh' \
        https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/bin/fzf-preview.sh

zinit wait lucid for \
    id-as'fzf-git.sh' \
        https://raw.githubusercontent.com/junegunn/fzf-git.sh/refs/heads/main/fzf-git.sh

zinit wait lucid for \
    as"program" \
    from"gh-r" \
    mv"ripgrep* -> ripgrep" \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/ripgrep/rg $ZPFX/bin;
    ' \
    atpull"%atclone" \
    pick'$ZPFX/bin/rg' \
        BurntSushi/ripgrep

# sharkdp/bat 名稱前面需要加上 @ 因為 zinit 會把它誤認為 sh'arkdp/bat' 因為有 sh 這個 ice
# 文件：https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/#a_few_remarks
zinit wait lucid for \
    as"program" \
    from"gh-r" \
    mv"bat* -> bat" \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/bat/bat $ZPFX/bin;
        cp bat/autocomplete/bat.zsh bat/_bat;
    ' \
    atpull"%atclone" \
    pick'$ZPFX/bin/bat' \
        @sharkdp/bat

# sharkdp/fd 名稱前面需要加上 @ 因為 zinit 會把它誤認為 sh'arkdp/fd' 因為有 sh 這個 ice
# 文件：https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/#a_few_remarks
zinit wait lucid for \
    as"program" \
    from"gh-r" \
    mv"fd* -> fd" \
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/fd/fd $ZPFX/bin;
    ' \
    atpull"%atclone" \
    pick'$ZPFX/bin/fd' \
        @sharkdp/fd

# Load custom

zinit is-snippet link for \
    ${HOME}/.dotfiles/zsh/custom/golang.zsh

zinit wait lucid is-snippet link for \
    ${HOME}/.dotfiles/zsh/custom/alias.zsh \
    ${HOME}/.dotfiles/zsh/custom/config.zsh \
    has'terraform' \
        ${HOME}/.dotfiles/zsh/custom/terraform.zsh


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
    atclone'
        mkdir -p $ZPFX/bin;
        ln -svf $PWD/starship $ZPFX/bin;
        ./starship init zsh > init.zsh;
        ./starship completions zsh > _starship;
    ' \
    atpull"%atclone" \
    src"init.zsh" \
    pick'$ZPFX/bin/starship'

export VIRTUAL_ENV_DISABLE_PROMPT=true  # Starship will control venv prompt.
export STARSHIP_CONFIG=${HOME}/.dotfiles/zsh/theme/starship.toml
zinit light starship/starship

# set completion colors to be the same as `ls`, after theme has been loaded
[[ -z "$LS_COLORS" ]] || zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
