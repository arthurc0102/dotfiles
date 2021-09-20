export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER="less -FX"
export PATH="$HOME/.local/bin:$PATH"

# My Scripts
if [ -d "$HOME/.dotfiles/scripts" ]; then
    export PATH="$HOME/.dotfiles/scripts:$PATH"
fi

# MySQL Config
if [ -d "/usr/local/opt/mysql-client/bin" ]; then
    export PATH="/usr/local/opt/mysql-client/bin:$PATH"
fi

# Pyenv Config
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Pipx Config
export PIPX_HOME="$HOME/.pipx"
export PIPX_BIN_DIR="$PIPX_HOME/bin"
export PATH="$PIPX_BIN_DIR:$PATH"

# Load local Config
[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
