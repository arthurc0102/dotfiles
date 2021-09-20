# Pipenv
export PIPENV_VENV_IN_PROJECT=true

add-zsh-hook -d chpwd _togglePipenvShell  # Disable automatic pipenv shell activation/deactivation

# Pipx
if command -v register-python-argcomplete > /dev/null; then
    eval "$(register-python-argcomplete pipx)"
else
    echo "Command 'register-python-argcomplete' not found. If you need autocomplete for 'pipx' install it."
fi
