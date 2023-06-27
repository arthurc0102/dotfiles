export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER="less -FX"
export PATH="$HOME/.local/bin:$PATH"

# My Scripts
if [ -d "$HOME/.dotfiles/scripts" ]; then
    export PATH="$HOME/.dotfiles/scripts:$PATH"
fi

# MySQL Client Config
if command -v brew > /dev/null && [ -d "$(brew --prefix mysql-client)/bin" ]; then
    export PATH="$(brew --prefix mysql-client)/bin:$PATH"
elif [ -d "/usr/local/opt/mysql-client/bin" ]; then
    export PATH="/usr/local/opt/mysql-client/bin:$PATH"
fi

# Pipx Config
export PIPX_HOME="$HOME/.pipx"
export PIPX_BIN_DIR="$PIPX_HOME/bin"
export PATH="$PIPX_BIN_DIR:$PATH"

# Pyenv Config
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# OrbStack Config
if [ -f "$HOME/.orbstack/shell/init.zsh" ]; then
    source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# Load local Config
[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
