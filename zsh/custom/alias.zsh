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

# Jump
alias j='jump'  # Jump to a directory
alias jc='mark'  # Mark the current directory
alias jd='unmark'  # Unmark the current directory
alias jl='marks'  # List all marks

# Fzf
alias fzf-finder='FZF_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND --type f" fzf --style full --height 100% --preview "fzf-preview.sh {}" --bind "ctrl-u:preview-up,ctrl-d:preview-down,enter:become(realpath {})"'
