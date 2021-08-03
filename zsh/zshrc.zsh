export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.dotfiles/zsh/custom"

ZSH_CACHE_DIR="$ZSH/cache"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

ZSH_THEME="spaceship"

plugins=(
  # Plugins
  git
  ssh-agent
  pip
  pipenv
  pyenv
  docker
  docker-compose
  web-search

  # Other Plugins
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-nvm

  # My Plugins
  poetry
)

export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true

zstyle :omz:plugins:ssh-agent identities $SSH_AGENT_IDENTITIES

source "$ZSH/oh-my-zsh.sh"


# # antigen bundle qoomon/zsh-lazyload
# # antigen bundle zpm-zsh/clipboard

# ## Lazyload
# # lazyload pyenv python pip pipx -- 'load_pyenv'
# # lazyload nvm node npm npx git-cz -- 'load_nvm'
