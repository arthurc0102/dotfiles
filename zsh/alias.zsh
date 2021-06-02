alias fd='echo ${PWD##*/}'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias gz='git-cz'  # full command to target lazyload
alias gitignore="git-ignore"

# Remove last newline char and add to clipboard. ('\r\n' work on Mac, Linux and Windows)
alias tc='python -c "import sys; print(sys.stdin.read().rstrip(\"\r\n\"), end=\"\")" | pbcopy'

# Python
alias pip-activate="source ./.venv/bin/activate"
alias pip-make-list="pip freeze > requirements.txt"
