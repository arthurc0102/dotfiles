# Repo: https://github.com/arthurc0102/dotfiles
set -e

command -v git > /dev/null || { echo "Git not installed"; exit 1; }

if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/arthurc0102/dotfiles.git $HOME/.dotfiles
fi

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

cd $HOME/.dotfiles

git submodule init
git submodule update

if [ ! -d "$HOME/.pip" ]; then
    mkdir $HOME/.pip
fi

ln -s $HOME/.dotfiles/zsh $HOME/.zsh
ln -s $HOME/.dotfiles/zshrc.zsh $HOME/.zshrc
ln -s $HOME/.dotfiles/gitconfig $HOME/.gitconfig
ln -s $HOME/.dotfiles/pip.conf $HOME/.pip/pip.conf
ln -s $HOME/.dotfiles/tmux.conf $HOME/.tmux.conf
ln -s $HOME/.dotfiles/pypirc $HOME/.pypirc
ln -s $HOME/.dotfiles/czrc $HOME/.czrc

if [ $(uname) != "Darwin" ]; then  # No conky for OSX
    if [ -d "$HOME/.local/share/applications" ]; then  # No conky for no GUI
        ln -s $HOME/.dotfiles/conkyrc $HOME/.conkyrc
        ln -s $HOME/.dotfiles/conky.desktop $HOME/.local/share/applications
    fi
fi
