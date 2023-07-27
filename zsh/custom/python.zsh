# Pipx
if command -v pipx > /dev/null; then
    if command -v register-python-argcomplete > /dev/null; then
        eval "$(register-python-argcomplete pipx)"
    else
        echo "Command 'register-python-argcomplete' not found. If you need autocomplete for 'pipx' install package 'argcomplete'."
    fi
fi

# Pyenv
if command -v pyenv > /dev/null; then
    # 不使用 Oh-My-Zsh 的 pyenv plugin 的原因是因為我們使用非同步的方法 init pyenv 但他們呼叫 init 時會重新設定 PATH
    # 造成 poetry shell 無法正常使用，所以我們自己 init 並透過 `--no-push-path` 讓 PATH 不進行重新設定

    # Add pyenv shims to $PATH if not already added
    if [[ -z "${path[(Re)$(pyenv root)/shims]}" ]]; then
        eval "$(pyenv init --path)"
    fi

    # Load pyenv
    eval "$(pyenv init - --no-rehash --no-push-path zsh)"

    # If pyenv-virtualenv exists, load it
    if [[ "$ZSH_PYENV_VIRTUALENV" != false && "$(pyenv commands)" =~ "virtualenv-init" ]]; then
        eval "$(pyenv virtualenv-init - zsh)"
    fi
fi
