if [ -d "$HOME/Android/sdk" ]; then
    # ANDROID_SDK_ROOT for Linux
    export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
fi

if [ -d "$HOME/Library/Android/sdk" ]; then
    # ANDROID_SDK_ROOT for OSX
    export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
fi

if [ $ANDROID_SDK_ROOT ]; then
    # if ANDROID_SDK_ROOT exits
    export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
    export PATH="$PATH:$ANDROID_SDK_ROOT/tools"
    export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
fi
