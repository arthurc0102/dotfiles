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
