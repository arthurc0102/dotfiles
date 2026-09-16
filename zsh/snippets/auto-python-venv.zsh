AUTO_PYTHON_VENV_NAME=".venv"

# venv's own `deactivate` restores PATH wholesale from the snapshot it took when
# the venv was activated, so it silently undoes every PATH change made in between.
# mise's chpwd hook is one of those: it adds a project's tool paths moments before
# this hook runs, and the snapshot restore would wipe them while mise's bookkeeping
# still reads as "already applied", leaving the tools missing until the next cd.
# Drop just the venv's own bin entry instead, which leaves the rest of PATH intact
# and makes this hook order-independent with respect to mise's.
function deactivate-closest-python-venv() {
    [[ -z "$VIRTUAL_ENV" ]] && return

    path=("${(@)path:#$VIRTUAL_ENV/bin}")
    unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT _OLD_VIRTUAL_PATH
    declare -f deactivate > /dev/null && unset -f deactivate
}

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
        deactivate-closest-python-venv
        return
    fi

    # If the founded venv is the current activated venv, do nothing. VIRTUAL_ENV is
    # exported, so a pane spawned by herdr/tmux can inherit it from the server
    # without the matching PATH; require the venv's bin to really be on PATH before
    # trusting it, otherwise fall through and activate for real.
    if [[
        "$AUTO_PYTHON_VENV_CURRENT_VENV_ROOT/$AUTO_PYTHON_VENV_NAME" == "$VIRTUAL_ENV" &&
        -n "${path[(r)$VIRTUAL_ENV/bin]}"
    ]]; then
        return
    fi

    # Deactivate the current venv (if any) and activate the found venv.
    deactivate-closest-python-venv
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
