export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.dotfiles/zsh/custom"

ZSH_CACHE_DIR="$ZSH/cache"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

ZSH_THEME="spaceship"

plugins=(
  # Plugins
  cp
  git
  pip
  pipenv
  pyenv
  docker
  docker-compose
  web-search
  direnv
  poetry
  httpie
  brew

  # Other Plugins
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-nvm
)

export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

source "$ZSH/oh-my-zsh.sh"
