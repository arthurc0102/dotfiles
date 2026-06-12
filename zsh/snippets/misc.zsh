function upgrade_all() {
    setopt localoptions ERR_RETURN

    if command -v brew &> /dev/null; then
        echo "Updating Homebrew and upgrading installed packages..."
        brew update
        brew upgrade
    fi

    echo

    if command -v apt &> /dev/null; then
        echo "Updating apt and upgrading installed packages..."
        sudo apt update
        sudo apt upgrade
        sudo apt autoremove
    fi

    echo

    if command -v uv &> /dev/null; then
        echo "Updating uv and upgrading global tools..."
        uv self update
        uv tool upgrade --all
    fi

    echo

    if command -v zinit &> /dev/null; then
        echo "Updating zinit and upgrading plugins..."
        zinit update --all
    fi

    echo

    if command -v mise &> /dev/null; then
        echo "Updating mise"
        mise self-update
    fi

    echo

    if command -v claude &> /dev/null; then
        echo "Updating claude code..."
        claude update
    fi

    echo

    if command -v doom &> /dev/null; then
        echo "Updating doom emacs..."
        doom upgrade
        doom sync
    fi

    echo

    local tmux_plugin_dir="$XDG_CONFIG_HOME/tmux/plugins/tpm"
    if [[ -d "$tmux_plugin_dir" ]]; then
        echo "Updating tmux plugins..."
        git -C "$tmux_plugin_dir" pull
        "$tmux_plugin_dir"/bin/update_plugins all
    fi
}
