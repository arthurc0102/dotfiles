alias l='ls -lF'
alias fd='echo ${PWD##*/}'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit -a'
alias gcl='git clone'
alias gd='git diff'
alias gl='git l'
alias gm='git commit -m'
alias gp='git push'
alias gpp='git pull'
alias gpc='git pc'
alias gs='git status'
alias gz='git-cz'  # full command to target lazyload
alias gitignore="git-ignore"

# Remove last newline char and add to clipboard. ('\r\n' work on Mac, Linux and Windows)
alias tc='python -c "import sys; print(sys.stdin.read().rstrip(\"\r\n\"), end=\"\")" | pbcopy'

# Python
alias pip-activate="source ./.venv/bin/activate"
alias pip-make-list="pip freeze > requirements.txt"
