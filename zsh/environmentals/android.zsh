if [ -d "$HOME/Android/sdk" ]; then
    # ANDROID_HOME for Linux
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

if [ -d "$HOME/Library/Android/sdk" ]; then
    # ANDROID_HOME for OSX
    export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

if [ $ANDROID_HOME ]; then
    # if ANDROID_HOME exits
    export PATH="$PATH:$ANDROID_HOME/emulator"
    export PATH="$PATH:$ANDROID_HOME/tools"
    export PATH="$PATH:$ANDROID_HOME/platform-tools"
fi
