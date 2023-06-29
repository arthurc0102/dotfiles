# Commitizen
if command -v cz > /dev/null; then
    if command -v register-python-argcomplete > /dev/null; then
        eval "$(register-python-argcomplete cz)"
    else
        echo "Command 'register-python-argcomplete' not found. If you need autocomplete for 'cz' install package 'argcomplete'."
    fi
fi
