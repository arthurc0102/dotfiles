AUTO_PYTHON_VENV_NAME=".venv"

# venv's own `deactivate` restores PATH wholesale from the snapshot it took when
# the venv was activated, so it silently undoes every PATH change made in between.
# mise's chpwd hook is one of those: it adds a project's tool paths moments before
# this hook runs, and the snapshot restore would wipe them while mise's bookkeeping
# still reads as "already applied", leaving the tools missing until the next cd.
# Drop just the venv's own bin entry instead, which leaves the rest of PATH intact
# and makes this hook order-independent with respect to mise's. PYTHONHOME is
# still restored the way `deactivate` would, since `activate` unsets it.
function deactivate-closest-python-venv() {
    [[ -z "$VIRTUAL_ENV" ]] && return

    # Inner quotes keep the match literal even under GLOB_SUBST.
    path=("${(@)path:#"$VIRTUAL_ENV/bin"}")
    [[ -n "$_OLD_VIRTUAL_PYTHONHOME" ]] && export PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
    unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT _OLD_VIRTUAL_PATH _OLD_VIRTUAL_PYTHONHOME
    declare -f deactivate > /dev/null && unset -f deactivate
}

function activate-closest-python-venv() {
    if [[ -n "$AUTO_PYTHON_VENV_DISABLE" ]] || [[ -n "$POETRY_ACTIVE" ]]; then
        return
    fi

    # Walk up from $PWD on every cd. `:h` is a builtin modifier, so the walk forks
    # nothing and is cheap enough that caching the last venv root isn't worth it
    # (a cache also misses a nested venv between the cached root and $PWD). Parents
    # are taken from the resolved path (`:A`), so a symlink into a project's subdir
    # still finds the project's venv rather than one along the symlink's own path.
    local venv="" check="$PWD"
    while true; do
        if [[ -f "$check/$AUTO_PYTHON_VENV_NAME/bin/activate" ]]; then
            venv="$check/$AUTO_PYTHON_VENV_NAME"
            break
        fi

        [[ "$check" == "/" ]] && break  # Check until root directory (include root directory).
        check="${check:A:h}"
    done

    # If venv is not found, deactivate the venv (if any).
    if [[ -z "$venv" ]]; then
        deactivate-closest-python-venv
        return
    fi

    # If the found venv is the current activated venv, do nothing. `activate` bakes in
    # the path the venv was created at, which differs from $PWD's logical path when
    # the project is reached through a symlink, so compare resolved paths. VIRTUAL_ENV
    # is exported, so a pane spawned by herdr/tmux can inherit it from the server
    # without the matching PATH; require the venv's bin to really be on PATH before
    # trusting it, otherwise fall through and activate for real. `(re)` matches the
    # entry literally, so glob characters in the path aren't read as a pattern.
    # `activate` also unsets PYTHONHOME, which would otherwise break the venv's
    # Python; a set one means activation didn't happen in this shell, so redo it.
    if [[
        "${venv:A}" == "${VIRTUAL_ENV:A}" &&
        -n "${path[(re)$VIRTUAL_ENV/bin]}" &&
        -z "$PYTHONHOME"
    ]]; then
        return
    fi

    # Deactivate the current venv (if any) and activate the found venv.
    deactivate-closest-python-venv
    source "$venv/bin/activate"
}

add-zsh-hook chpwd activate-closest-python-venv


# chpwd doesn't fire for the directory a shell starts in, so check once on the
# first prompt (e.g. a new tmux/herdr pane opened inside a project), then unhook.
function activate-closest-python-venv-on-start() {
    add-zsh-hook -d precmd activate-closest-python-venv-on-start
    activate-closest-python-venv
}

add-zsh-hook precmd activate-closest-python-venv-on-start
