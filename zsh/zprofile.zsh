export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER="less -FX"
export PATH="$HOME/.local/bin:$PATH"

export HOMEBREW_NO_ANALYTICS=1

# 手動設定 Brew 相關的參數，需要在 Pyenv 與 MySQL 前面，避免找不到 Brew 或是與 Pyenv 的 Python 打架。
# Copy from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/brew/brew.plugin.zsh#L1
if (( ! $+commands[brew] )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_LOCATION="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_LOCATION="/usr/local/bin/brew"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    BREW_LOCATION="/home/linuxbrew/.linuxbrew/bin/brew"
  elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    BREW_LOCATION="$HOME/.linuxbrew/bin/brew"
  else
    return
  fi

  # Only add Homebrew installation to PATH, MANPATH, and INFOPATH if brew is
  # not already on the path, to prevent duplicate entries. This aligns with
  # the behavior of the brew installer.sh post-install steps.
  eval "$("$BREW_LOCATION" shellenv)"
  unset BREW_LOCATION
fi

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
export PIPX_HOME="$HOME/.local/share/pipx"

# Pyenv Config
export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ]; then
    command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
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
