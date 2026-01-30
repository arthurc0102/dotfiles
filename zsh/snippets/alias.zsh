# Ping
alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

# Git
if command -v cz > /dev/null; then
    alias gz='cz c'  # Install package 'commitizen' with npm or pip globally
elif command -v uvx > /dev/null; then
    alias gz='uvx --from=commitizen cz c'
fi

alias gitignore='git-ignore'
alias gdf='git diff'
alias gd='git -c delta.side-by-side=true diff'

# Folder
alias current_dir='echo ${PWD##*/}'

# Python
alias python-executable-path='python -c "import sys; print(sys.executable)"'

# Suffix
alias -s json='fx'

# Global
alias -g C='| clipcopy'
alias -g W='| wc -c'
alias -g L='| wc -l'
alias -g NO='> /dev/null'  # No output
alias -g NE='2> /dev/null'  # No error output
alias -g NOE='&> /dev/null'  # No output and error output

# DNS
if [[ $(uname) == 'Darwin' ]]; then
    alias dns-flush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
fi
