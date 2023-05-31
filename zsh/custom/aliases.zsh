# CLI Shortcuts
alias zshconfig="subl ~/.zshrc"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"

# Shortcuts
alias s="subl ."
alias o="open ."

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# List all files colorized in long format
alias l="ls -l ${colorflag}"
alias ll="$(brew --prefix coreutils)/libexec/gnubin/ls -ahlF --color --group-directories-first"
alias la="ls -la ${colorflag}"
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

#Stop and remove all docker containers and images - https://blog.baudson.de/blog/stop-and-remove-all-docker-containers-and-images
alias fuckdocker="docker stop $(docker ps -aq) | docker rm $(docker ps -aq) | docker rmi $(docker images -q)"

alias g="git"
alias gs="git status"
alias ga="git add ../.."
alias gpl="git pull"
alias gps="git push"