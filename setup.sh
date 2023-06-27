# Repo: https://github.com/arthurc0102/dotfiles
set -e

check() {
    echo "Check."
    command -v git > /dev/null || { echo "Git not installed"; exit 1; }
}

setup_ohmyzsh() {
    echo "Setup oh-my-zsh"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
    fi
}

setup_dotfiles() {
    echo "Setup dotfiles"
    if [ ! -d "$HOME/.dotfiles" ]; then
        git clone --recursive https://github.com/arthurc0102/dotfiles.git $HOME/.dotfiles
    fi
}

setup_tmux() {
    echo "Setup tmux"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    fi

    ln -svf $HOME/.dotfiles/tmux/tmux.conf $HOME/.tmux.conf
    cp -v $HOME/.dotfiles/tmux/tmux.local.conf $HOME/.tmux.local.conf
}

setup_git() {
    echo "Setup git"
    ln -svf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
    ln -svf $HOME/.dotfiles/git/git-cz.json $HOME/.git-cz.json
    cp -v $HOME/.dotfiles/git/gitconfig.user $HOME/.gitconfig.user
}

setup_karabiner() {
    if [ $(uname) != "Darwin" ]; then
        return;
    fi

    echo "Setup karabiner"

    if [ ! -d "$HOME/.config/karabiner" ]; then
        mkdir -pv $HOME/.config/karabiner
    fi

    ln -svf $HOME/.dotfiles/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json
}

setup_zsh() {
    echo "Setup zsh"
    ln -svf $HOME/.dotfiles/zsh/zshrc.zsh $HOME/.zshrc
    ln -svf $HOME/.dotfiles/zsh/zprofile.zsh $HOME/.zprofile
    cp -v $HOME/.dotfiles/zsh/zprofile.local.zsh $HOME/.zprofile.local
}

setup_ssh() {
    echo "Setup ssh"

    mkdir -pv $HOME/.ssh
}

main() {
    check
    setup_ohmyzsh
    setup_dotfiles
    setup_tmux
    setup_git
    setup_karabiner
    setup_zsh
    setup_ssh
}

main
