export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER="less -FX"
export PATH="$HOME/.local/bin:$PATH"

export HOMEBREW_NO_ANALYTICS=1
export UV_MANAGED_PYTHON=true
export UV_PYTHON_INSTALL_BIN=false

# My Scripts
if [ -d "$HOME/.dotfiles/bin" ]; then
    export PATH="$HOME/.dotfiles/bin:$PATH"
fi

# MySQL Client Config
if command -v brew > /dev/null && [ -d "$(brew --prefix mysql-client)/bin" ]; then
    export PATH="$(brew --prefix mysql-client)/bin:$PATH"
elif [ -d "/usr/local/opt/mysql-client/bin" ]; then
    export PATH="/usr/local/opt/mysql-client/bin:$PATH"
fi

# OrbStack Config
if [ -f "$HOME/.orbstack/shell/init.zsh" ]; then
    source $HOME/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# 1Password SSH Config: https://developer.1password.com/docs/ssh/get-started/
if [ -S "$HOME/.1password/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
elif [ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

# Load local Config
[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
