# Load antigen
source $HOME/.zsh/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load plugins
antigen bundle cp
antigen bundle pip
antigen bundle copydir
antigen bundle web-search
antigen bundle command-not-found
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# powerlevel9k settings
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv ssh context dir rbenv vcs dir_writable)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

# Theme settings
antigen theme bhilburn/powerlevel9k powerlevel9k

# Apply settings
antigen apply

# Custom settings
source $HOME/.zsh/alias
source $HOME/.zsh/environmental

