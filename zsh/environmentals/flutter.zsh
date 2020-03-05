if [ -d "$HOME/.pub-cache/bin" ]; then
    export PATH="$PATH":"$HOME/.pub-cache/bin"
fi

if [ -d "$HOME/Library/flutter/bin" ]; then
    export PATH="$PATH":"$HOME/Library/flutter/bin"
fi
