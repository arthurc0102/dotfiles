alias fd='echo ${PWD##*/}'

alias pp='ping 8.8.8.8'
alias pd='ping fb.me'

alias gz='git-cz'  # Install with 'npm install -g commitizen'
alias gitignore="git-ignore"

alias emacs-origin="$(which emacs)"  # Backup origin emacs command
alias emacs-kill-server='emacsclient -e "(kill-emacs)"'
alias emacs='emacsclient --alternate-editor="" --create-frame'
