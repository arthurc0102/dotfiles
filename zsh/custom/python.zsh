# Pipenv
export PIPENV_VENV_IN_PROJECT=true

add-zsh-hook -d chpwd _togglePipenvShell  # Disable automatic pipenv shell activation/deactivation

# Pipx
eval "$(register-python-argcomplete pipx)"
