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

# 1Password SSH Config: https://developer.1password.com/docs/ssh/get-started/
if [ -S "$HOME/.1password/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
elif [ -S "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

# Local Config
[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
