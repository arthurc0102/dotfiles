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
