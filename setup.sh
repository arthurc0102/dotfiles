set -e

check() {
    echo "Checked"
    command -v git > /dev/null || { echo "Git not installed"; exit 1; }
}

setup_dotfiles() {
    echo "Setup dotfiles"
    if [ ! -d "${DOTFILES_HOME}" ]; then
        git clone https://github.com/arthurc0102/dotfiles.git ${DOTFILES_HOME}
    fi
}

setup_tmux() {
    echo "Setup tmux"
    if [ ! -d "${HOME}/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    fi

    ln -svf ${DOTFILES_HOME}/tmux/tmux.conf $HOME/.tmux.conf

    if [ ! -f "${HOME}/.tmux.local.conf" ]; then
        cp -v ${DOTFILES_HOME}/tmux/tmux.local.conf ${HOME}/.tmux.local.conf
    fi
}

setup_git() {
    echo "Setup git"
    ln -svf ${DOTFILES_HOME}/git/gitconfig ${HOME}/.gitconfig

    if [ ! -f "${HOME}/.gitconfig.user" ]; then
        cp -v ${DOTFILES_HOME}/git/gitconfig.user ${HOME}/.gitconfig.user
    fi
}

setup_zsh() {
    echo "Setup zsh"
    ln -svf ${DOTFILES_HOME}/zsh/zshrc.zsh ${HOME}/.zshrc
    ln -svf ${DOTFILES_HOME}/zsh/zprofile.zsh ${HOME}/.zprofile

    if [ ! -f "${HOME}/.zprofile.local" ]; then
        cp -v ${DOTFILES_HOME}/zsh/zprofile.local.zsh ${HOME}/.zprofile.local
    fi
}

setup_vim() {
    echo "Setup vim"
    if [ ! -f "${HOME}/.vimrc" ]; then
        ln -svf ${DOTFILES_HOME}/vim/vimrc ${HOME}/.vimrc
    else
        echo "Skip vim setup because config file already found"
    fi
}

install_uv() {
    if command -v uv > /dev/null; then
        echo "UV already installed"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
}

setup_emacs() {
    echo "Setup emacs"

    if [ ! -d "${HOME}/.emacs.d" ]; then
        git clone https://github.com/syl20bnr/spacemacs ${HOME}/.emacs.d
    else
        echo "Skip spacemacs download because '.emacs.d' folder exists"
    fi

    ln -svf ${DOTFILES_HOME}/emacs/spacemacs ${HOME}/.spacemacs
}

main() {
    export DOTFILES_HOME="${HOME}/.dotfiles"

    check
    echo
    setup_dotfiles
    echo
    setup_tmux
    echo
    setup_git
    echo
    setup_zsh
    echo
    setup_vim
    echo
    install_uv
    # echo
    # setup_emacs

    unset DOTFILES_HOME
}

main
