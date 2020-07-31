# this file was heavily based on https://github.com/w3cj/dotfiles
# install the latest bash
# brew install bash;echo /usr/local/bin/bash|sudo tee -a /etc/shells;chsh -s /usr/local/bin/bash

# colors guide: https://misc.flogisoft.com/bash/tip_colors_and_formatting

HOST_NAME="⚡️"

shopt -s autocd

export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=~/bin:$PATH
export PATH=$PATH:$HOME/bin

# WHAT DO THESE DO?
# shopt -s histappend
# export HISTSIZE=5000
# export HISTFILESIZE=10000
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

txtyel='\e[0;33m' # Yellow
txtmag='\e[1;35m' # Magenta
txtcya='\e[1;36m' # Cyan
txtrst='\e[0m'    # Text Reset

emojis=("👾" "💎" "⚡️" "🦄" "☄️" "🚀")

EMOJI=${emojis[$RANDOM % ${#emojis[@]} ]}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "(${BRANCH}${STAT}) "
	else
		echo ""
	fi
}

print_before_the_prompt () {
    dir=$PWD
    home=$HOME
    dir=${dir/"$HOME"/"~"}
    # printf "\n$txtyel%s @ %s $txtcya%s\n$txtrst" "$HOST_NAME" "$dir" "$(vcprompt)"
    printf "$EMOJI $txtyel@ %s  $txtcya%s\n$txtrst" "$dir" "$(parse_git_branch)"
}

PROMPT_COMMAND=print_before_the_prompt
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
PS1="$txtmag-> $txtrst "

function mkcd() {
    mkdir $1 && cd $1
}

# -------
# Aliases
# -------
alias 🍺="git checkout -b drunk"
alias a='code .'
alias c='code .'
alias reveal-md="reveal-md --theme night --highlight-theme hybrid --port 1337"
alias ns='npm start'
alias start='npm start'
alias nr='npm run'
alias run='npm run'
alias nis='npm i -S'
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gi='git init'
alias gl='git log'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'

# ----------------------
# Additional PATH config
# ----------------------
export PATH=$PATH:~/.nexustools

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

PATH=${PATH}:/usr/local/mysql/bin
export PATH

PATH="$PATH:/Users/jahirfiquitiva/Dev/Flutter/sdk/flutter/bin"
export PATH

export ANDROID_HOME="/Users/jahirfiquitiva/Dev/Android/SDK"

# Enable git completion
test -f ~/.git-completion.bash && . $_

# ----------------------
# Extra Aliases
# ----------------------
UPTC_PROXY="http://192.168.3.5:8080"
alias setuptcproxy='export {http,https,ftp,rsync}_proxy=$UPTC_PROXY && export {HTTP,HTTPS,FTP,RSYNC}_PROXY=$UPTC_PROXY'
alias unsetproxy='export {http,https,ftp,rsync}_proxy="" && export {HTTP,HTTPS,FTP,RSYNC}_PROXY=""'

alias mongod="mongod --dbpath /usr/local/var/mongodb"

alias php='/usr/bin/php'
alias phpdeploy='sudo /usr/bin/php -S localhost:80 -t'
alias phpold='/usr/local/opt/php@5.6/bin/php'

alias pentaho='/Applications/Pentaho/Data\ Integration.app/Contents/MacOS/JavaApplicationStub ; exit;'

alias lsalias="grep -in --color -e '^alias\s+*' ~/.bash_profile | sed 's/alias //' | grep --color -e ':[a-z][a-z0-9]*'" # prints all custom alias
alias please="sudo"
alias del="rm -rf"
alias colors="npx colortest"

# ----------------------
# Google Cloud Stuff
# ----------------------

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jahirfiquitiva/google-cloud-sdk/path.bash.inc' ]; then . '/Users/jahirfiquitiva/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jahirfiquitiva/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/jahirfiquitiva/google-cloud-sdk/completion.bash.inc'; fi
