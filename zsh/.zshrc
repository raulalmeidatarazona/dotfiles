# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/raul/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

############################## Custom Bindings ###################################

######## para moverte por los directorios#####
_display_message() {
  dirtomove=$(ls | fzf)
  cd "$dirtomove"
}

zle         -N    _display_message
bindkey  '^h'  _display_message
################################################

##################### busca inversa de comandos vitaminada #########################
_reverse_search() {
  local selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | fzf)
  LBUFFER=$selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search
####################################################################################

######################## Parar y eliminar un contenedor #############################
_display_docker() {
    dockerps=$(docker ps --format '{{.ID}}\t{{.Names}}\t\t{{.Image}}\t\t{{.Status}}')
    container=$(echo $dockerps | fzf --layout=reverse-list --header "<CONTAINER ID> <NAME> <IMAGE> <Status>" --tabstop=4)
    containerid=$(echo $container | awk '{print $1;}')
    containername=$(echo $container | awk '{print $2;}')

    answer=$(echo "No\nYes" | fzf --tac --no-sort --header "Do you want to stop the container <${containername}> (if is not stopped) and removeit?")

    case ${answer:0:1} in
        [nN])
            #echo "Nothing to do. Bye!"
            ;;
        *)
            if [[ ! -z $containerid ]]; then
                docker stop -t 0 "$containerid"
                docker rm -v "$containerid"
            fi
            ;;
    esac
}

zle -N _display_docker
bindkey '^k' _display_docker
#########################################################################


############################# Custom Function ###########################
################################ Docker #################################
##docker_list
function docker_list () {
containers=$(docker ps | awk '{if (NR!=1) print $1 ": " $(NF)}')
echo "👇 Containers 👇"
echo $containers
}
##docker_connect
function docker_connect (){
if docker ps >/dev/null 2>&1; then
  container=$(docker ps | awk '{if (NR!=1) print $1 ": " $(NF)}' | fzf --height 40%)

  if [[ -n $container ]]; then
    container_id=$(echo $container | awk -F ': ' '{print $1}')

    docker exec -it $container_id /bin/bash || docker exec -it $container_id /bin/sh
  else
    echo "You haven't selected any container! ༼つ◕_◕༽つ"
  fi
else
  echo "Docker daemon is not running! (ಠ_ಠ)"
fi}
##docker_prune
function docker_prune(){
docker stop $(docker ps -a -q)
yes | docker system prune -a
}

################################## System ###############################
############system update ############
function up {
sudo apt update;
pkcon update
}
#######################################

#############system clean##############
function clean(){
sudo apt-get autopurge;
sudo apt-get autoremove;
sudo apt-get autoclean
}
#######################################
################################## Git ###############################
#commit
function gac {
if (! git::is_in_repo); then
  echo "Not in a git repo!"
  exit 0
fi

git -c color.status=always status --short |
  fzf --height 100% --ansi \
    --preview '(git diff HEAD --color=always -- {-1} | sed 1,4d)' \
    --preview-window right:65% |
  cut -c4- |
  sed 's/.* -> //' |
  tr -d '\n' |
  xcopy
}
############################################################################
