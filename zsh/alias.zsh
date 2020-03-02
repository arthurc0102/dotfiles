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
alias gs='git status'
alias gz='git cz'

alias docker-image-clenup='docker rmi $(docker images -f "dangling=true" -q)'

alias lzd='lazydocker'

alias tc='python -c "import sys; print(\"\\n\".join(sys.stdin.read().splitlines()), end=\"\")" | pbcopy'
