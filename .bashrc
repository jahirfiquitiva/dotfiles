# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"
# Q pre block. Keep at the top of this file.

# this file was heavily based on https://github.com/w3cj/dotfiles

# install the latest bash, but probably not necessary
# brew install bash;echo /usr/local/bin/bash|sudo tee -a /etc/shells;chsh -s /usr/local/bin/bash

# colors guide: https://misc.flogisoft.com/bash/tip_colors_and_formatting
# git completion bash: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

ulimit -n 65536 200000
HOST_NAME="⚡️"

export BASH_SILENCE_DEPRECATION_WARNING=1
export PATH=~/bin:$PATH
export PATH=$PATH:$HOME/bin
export NX_TUI=false

# WHAT DO THESE DO?
# shopt -s autocd
# shopt -s histappend
# export HISTSIZE=5000
# export HISTFILESIZE=10000
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'

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

print_before_prompt () {
    dir=$PWD
    home=$HOME
    dir=${dir/"$HOME"/"~"}
    # printf "\n$txtyel%s @ %s $txtcya%s\n$txtrst" "$HOST_NAME" "$dir" "$(vcprompt)"
    printf "\n$EMOJI $txtyel@ %s $txtcya%s\n$txtrst" "$dir" "$(parse_git_branch)"
}

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
	export PROMPT_COMMAND=print_before_prompt
	# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
	# export PS1="$txtmag>  $txtrst"
fi
export PS1="\[\e[1;35m\]⇥  \[\e[0m\]"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

function mkcd() {
    mkdir $1 && cd $1
}

# -------
# Aliases
# -------
alias cls='clear'
#alias code='codium'
alias a='code .'
alias c='code .'
alias ns='npm start'
alias start='npm start'
alias nr='npm run'
alias run='npm run'
alias nis='npm i -S'
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder
alias node-prune='find . -name "node_modules" -type d -prune -exec rm -rf '{}' \;'

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gcamend='git commit --amend -m'
alias gacm='git add-commit -m'
alias gmac='gacm'
alias gacme='git add-commit -m --allow-empty'
alias gmace='gacme'
alias gd='git diff'
alias gi='git init'
alias gl='git log --oneline --decorate --all --graph'
alias gp='git pull'
alias gpsh='git push'
alias gss='git status -sb'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'
alias gignore='git update-index --assume-unchanged'

# ----------------------
# Additional PATH config
# ----------------------
export PATH=$PATH:~/.nexustools

# Setting PATH for Python 3.10
alias python='python3'
alias pip='pip3'
export PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"

PATH=${PATH}:/usr/local/mysql/bin
export PATH

export ANDROID_HOME="/Users/jahirfiquitiva/Library/Android/sdk"

# Enable git completion
test -f ~/.git-completion.bash && . $_
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

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
alias delempty="rm -rf */.DS_Store && rm -d *"
alias colors="npx colortest"
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export PATH="$PATH:/Users/jahirfiquitiva/Library/Application Support/JetBrains/Toolbox/scripts"

PATH=~/.console-ninja/.bin:$PATH

# Add spotify to path for spicetify
export PATH="$PATH:/Applications/Spotify.app/Contents/MacOS/Spotify"
alias spotify="/Applications/Spotify.app/Contents/MacOS/Spotify"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# pnpm
export PNPM_HOME="/Users/jahirfiquitiva/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.bash 2>/dev/null || :
# Q post block. Keep at the top of this file.

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"
