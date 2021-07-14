## Pyenv

export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

if [ -d "$PYENV_ROOT" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  source "${PYENV_ROOT}/completions/pyenv.zsh"
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

## Pipx

# echo "Install Pipx"
# export PYTHONUSERBASE=/tmp/pip-tmp
# export PIP_CACHE_DIR=/tmp/pip-tmp/cache
# pip install --disable-pip-version-check --no-warn-script-location  --no-cache-dir --user pipx
# /tmp/pip-tmp/bin/pipx install --pip-args=--no-cache-dir pipx
# rm -rf /tmp/pip-tmp

export PIPX_HOME="$HOME/.pipx"
export PIPX_BIN_DIR="$PIPX_HOME/bin"
export PATH="$PIPX_BIN_DIR:$PATH"
