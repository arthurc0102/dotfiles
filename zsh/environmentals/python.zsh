## Pyenv

export PYENV_ROOT="$HOME/.pyenv"

if [ -d "$PYENV_ROOT" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

load_pyenv() {
  # Skip pyenv step up when in pipenv shell or virtuarl env
  if [[ $PIPENV_ACTIVE -eq 1 || ! -z "$VIRTUAL_ENV" ]]; then
    return
  fi

  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
}

## Pipenv

export PIPENV_VENV_IN_PROJECT=true

## Poetry

if [ -d "$HOME/.poetry" ]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi
