# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# cd $brainstormr

# List directory contents
alias ls='lsd'
alias l.='ls -lF -d  .*' ##solo que empicen por .##
alias lsa='lsd -lah'
alias l='lsd -lah'
alias lat='lsd -lah --tree'
alias ll='lsd -lh'
alias la='lsd -lAh'
alias cdw='cd $HOME/Workspace'
alias cdd='cd $HOME/Workspace/dosfarma/'

# Docker
alias dl='docker_list'
alias dco='docker_connect'
alias dp='docker_prune'
alias dps='docker ps'
alias dpa='docker ps -a'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcud='docker-compose up -d'
alias dcd='docker-compose down'