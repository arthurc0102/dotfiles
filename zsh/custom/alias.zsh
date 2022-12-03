alias fd='echo ${PWD##*/}'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias gz='git-cz'  # full command to target lazyload
alias gitignore="git-ignore"

# Remove last newline char and add to clipboard. ('\r\n' work on Mac, Linux and Windows)
alias tc='python -c "import sys; print(sys.stdin.read().rstrip(\"\r\n\"), end=\"\")" | clipcopy'

# Python
alias py-venv="python -m venv .venv"
alias py-activate="source ./.venv/bin/activate"
alias py-shell="py-venv && py-activate"

alias pip-make-list="pip freeze > requirements.txt"

alias kraken="open -na 'GitKraken' --args -p $(pwd)"
