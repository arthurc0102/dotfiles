set -e

check() {
    echo "Checked"
    command -v git > /dev/null || { echo "Git not installed"; exit 1; }
}

setup_dotfiles() {
    echo "Setup dotfiles"
    if [ ! -d "$HOME/.dotfiles" ]; then
        git clone https://github.com/arthurc0102/dotfiles.git $HOME/.dotfiles
    fi
}

setup_tmux() {
    echo "Setup tmux"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    fi

    ln -svf $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf

    if [ ! -f "$HOME/.tmux.local.conf" ]; then
        cp -v $HOME/.dotfiles/tmux/tmux.local.conf $HOME/.tmux.local.conf
    fi
}

setup_git() {
    echo "Setup git"
    ln -svf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
    ln -svf $HOME/.dotfiles/git/czrc $HOME/.czrc

    if [ ! -f "$HOME/.gitconfig.user" ]; then
        cp -v $HOME/.dotfiles/git/gitconfig.user $HOME/.gitconfig.user
    fi
}

setup_zsh() {
    echo "Setup zsh"
    ln -svf $HOME/.dotfiles/zsh/zshrc.zsh $HOME/.zshrc
    ln -svf $HOME/.dotfiles/zsh/zprofile.zsh $HOME/.zprofile

    if [ ! -f "$HOME/.zprofile.local" ]; then
        cp -v $HOME/.dotfiles/zsh/zprofile.local.zsh $HOME/.zprofile.local
    fi
}

setup_pipx() {
    if command -v pip3 > /dev/null; then
        echo "Setup pipx"
        ./setup-pipx.sh
    else
        echo "Command 'pip3' not found skip pipx install, you can run 'setup-pipx.sh' later"
    fi
}

install_pyenv() {
    if [ ! -d "$HOME/.pyenv" ]; then
        echo "Install pyenv"
        curl https://pyenv.run | bash
    else
        echo "Pyenv already exists"
    fi
}

install_nvm() {
    local nvm_dir

    nvm_dir="$HOME/.nvm"

    if [ ! -d "$nvm_dir" ]; then
        echo "Install nvm"
        git clone https://github.com/nvm-sh/nvm.git "$nvm_dir"
        cd "$nvm_dir"
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    else
        echo "Nvm already exists"
    fi
}

main() {
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
    setup_pipx
    echo
    install_pyenv
    echo
    install_nvm
}

main
