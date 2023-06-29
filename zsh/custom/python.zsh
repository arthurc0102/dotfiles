# Pipx
if command -v register-python-argcomplete > /dev/null; then
    eval "$(register-python-argcomplete pipx)"
else
    echo "Command 'register-python-argcomplete' not found. If you need autocomplete for 'pipx' install package 'argcomplete'."
fi
