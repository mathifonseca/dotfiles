# CLI Shortcuts
alias zshconfig="subl ~/.zshrc"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"

# Shortcuts
alias s="subl ."
alias o="open ."

# Modern CLI replacements are in .zshrc (after oh-my-zsh source) to override defaults

# Stop and remove all docker containers and images
fuckdocker() {
  docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi $(docker images -q)
}

alias g="git"
alias gs="git status"
alias ga="git add ../.."
alias gpl="git pull"
alias gps="git push"