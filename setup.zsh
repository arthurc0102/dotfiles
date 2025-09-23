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

install_uv() {
    if command -v uv > /dev/null; then
        echo "Skip uv installation because it is already installed"
    else
        echo "Install uv"
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
}

install_doom_emacs() {
    if [[ -d $XDG_CONFIG_HOME/emacs ]]; then
        echo "Skip doom emacs installation because it is already installed"
    else
        echo "Install doom emacs"
        git clone --depth 1 https://github.com/doomemacs/doomemacs $XDG_CONFIG_HOME/emacs
        $XDG_CONFIG_HOME/emacs/bin/doom install
        $XDG_CONFIG_HOME/emacs/bin/doom sync
        ln -svf $XDG_CONFIG_HOME/emacs/bin/doom $HOME/.local/bin/doom
    fi
}

link_config_files() {
    if [ -z "$1" ]; then
        echo "No stow package specified."
        exit 1
    fi

    echo "Link config files from '$1'"
    stow --verbose --dotfiles --no-folding --restow --target=$HOME --ignore='.gitkeep' --dir=$DOTFILES_HOME $1
}

setup_local_config() {
    mkdir -pv $DOTFILES_HOME/stow-local/dot-config/git/
    touch $DOTFILES_HOME/stow-local/dot-config/git/config.local

    mkdir -pv $DOTFILES_HOME/stow-local/dot-config/zsh/
    touch $DOTFILES_HOME/stow-local/dot-config/zsh/dot-zshrc.local

    link_config_files stow-local
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

    setup_local_config
    echo

    if command -v emacs > /dev/null; then
        install_doom_emacs
        echo
    fi

    install_uv
}

main
