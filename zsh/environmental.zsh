export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -d "$HOME/Android/sdk" ]; then
    # ANDROID_HOME for Linux
    export ANDROID_HOME="$HOME/Android/Sdk"

fi

if [ -d "${HOME}/Library/Android/sdk" ]; then
    # ANDROID_HOME for OSX
    export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

if [ $ANDROID_HOME ]; then
    # if ANDROID_HOME exits
    export PATH="$PATH:$ANDROID_HOME/emulator"
    export PATH="$PATH:$ANDROID_HOME/tools"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi

if [ -d "$HOME/.pub-cache/bin" ]; then
    export PATH="$PATH":"$HOME/.pub-cache/bin"
fi

if [ -d "$HOME/Library/flutter/bin" ]; then
    export PATH="$PATH":"$HOME/Library/flutter/bin"
fi

if [ -d "${HOME}/go" ]; then
    export GOPATH="$HOME/go"
fi

if [ $GOPATH ]; then
    export PATH="$PATH:$GOPATH/bin"
fi

if [ -d "$HOME/.dotfiles/scripts" ]; then
    # My scripts
    export PATH="$PATH:$HOME/.dotfiles/scripts"
fi

# Fix emacs error
if [[ $TERM = dumb ]]; then
    unset zle_bracketed_paste
fi

if [ -d "${HOME}/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
fi

if [ $NVM_DIR ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

if command -v pipenv 1>/dev/null 2>&1; then
    eval "$(pipenv --completion)"
    export PIPENV_VENV_IN_PROJECT=true
fi

if [ -d "$HOME/.rvm/bin" ]; then
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    export PATH="$PATH:$HOME/.rvm/bin"

    # Load RVM into a shell session *as a function*
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
fi

export PATH="$PATH:./bin"
export PAGER="less -FX"
