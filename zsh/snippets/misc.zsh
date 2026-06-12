function upgrade_all() {
    setopt localoptions ERR_RETURN

    echo "Updating Homebrew and upgrading installed packages..."
    if command -v brew &> /dev/null; then
        brew update
        brew upgrade
    fi

    echo
    echo "Updating apt and upgrading installed packages..."
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt upgrade
        sudo apt autoremove
    fi

    echo
    echo "Updating uv and upgrading global tools..."
    if command -v uv &> /dev/null; then
        uv self update
        uv tool upgrade --all
    fi

    echo
    echo "Updating zinit and upgrading plugins..."
    if command -v zinit &> /dev/null; then
        zinit update --all
    fi

    echo
    echo "Updating mise"
    if command -v mise &> /dev/null; then
        mise self-update
    fi

    echo
    echo "Updating claude code..."
    if command -v claude &> /dev/null; then
        claude update
    fi

    echo
    echo "Updating doom emacs..."
    if command -v doom &> /dev/null; then
        doom upgrade
        doom sync
    fi

    echo
    echo "Updating tmux plugins..."
    local tmux_plugin_dir="$XDG_CONFIG_HOME/tmux/plugins/tpm"
    if [[ -d "$tmux_plugin_dir" ]]; then
        git -C "$tmux_plugin_dir" pull
        "$tmux_plugin_dir"/bin/update_plugins all
    fi
}
