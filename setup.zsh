#!/bin/zsh

set -e

source $(dirname $0)/stow/dot-zshenv  # Load variables, like DOTFILES_HOME and XDG etc.

check() {
    command -v git > /dev/null || { echo "Git not installed."; exit 1; }
    command -v stow > /dev/null || { echo "GNU Stow not installed."; exit 1; }
}

install_dotfiles() {
    if [[ -d $DOTFILES_HOME ]]; then
        echo "Dotfiles already installed"
        return
    fi

    echo "Install dotfiles"
    git clone https://github.com/arthurc0102/dotfiles.git "$DOTFILES_HOME"
}

setup_git() {
    echo "Setup git"
    touch ~/.config/git/config.local
}

install_uv() {
    if command -v uv > /dev/null; then
        echo "Skip uv installation because it is already installed"
    else
        echo "Install uv"
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
}

link_config_files() {
    if [ -z "$1" ]; then
        echo "No stow package specified."
        exit 1
    fi

    echo "Link config files from '$1'"
    stow --verbose --dotfiles --no-folding --restow --target=$HOME --dir=$DOTFILES_HOME $1
}


main() {
    check

    install_dotfiles
    echo

    link_config_files stow
    echo

    if [[ $(uname) == "Darwin" ]]; then
        link_config_files stow-osx
        echo
    fi

    setup_git
    echo

    install_uv
}

main
