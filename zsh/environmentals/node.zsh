if [ -d "${HOME}/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
fi

if [ $NVM_DIR ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
