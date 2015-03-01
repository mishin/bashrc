# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

fi

# some more ls aliases

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
 cd_func ()
 {
   local x2 the_new_dir adir index
   local -i cnt
 
   if [[ $1 ==  "--" ]]; then
     dirs -v
     return 0
   fi
 
   the_new_dir=$1
   [[ -z $1 ]] && the_new_dir=$HOME
 
   if [[ ${the_new_dir:0:1} == '-' ]]; then
     #
     # Extract dir N from dirs
     index=${the_new_dir:1}
     [[ -z $index ]] && index=1
     adir=$(dirs +$index)
     [[ -z $adir ]] && return 1
     the_new_dir=$adir
   fi
 
   #
   # '~' has to be substituted by ${HOME}
   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
 
   #
   # Now change to the new dir and add to the top of the stack
   pushd "${the_new_dir}" > /dev/null
   [[ $? -ne 0 ]] && return 1
   the_new_dir=$(pwd)
 
   #
   # Trim down everything beyond 11th entry
   popd -n +11 2>/dev/null 1>/dev/null
 
   #
   # Remove any other occurence of this dir, skipping the top of the stack
   for ((cnt=1; cnt <= 10; cnt++)); do
     x2=$(dirs +${cnt} 2>/dev/null)
     [[ $? -ne 0 ]] && return 0
     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
     if [[ "${x2}" == "${the_new_dir}" ]]; then
       popd -n +$cnt 2>/dev/null 1>/dev/null
       cnt=cnt-1
     fi
   done
 
   return 0
 }
 

 
#Extract things. Thanks to urukrama, Ubuntuforums.org  
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
 
# Directory navigation aliases


# WELCOME SCREEN
#######################################################
 
clear
 
#echo -ne "${LIGHTGREEN}" "Hello, $USER. today is, "; date
echo -ne "${LIGHTGREEN}" "Hello, `whoami`. today is, "; date
echo -e "${WHITE}"; cal ;  
echo -ne "${CYAN}";
echo -ne "${LIGHTPURPLE}Sysinfo:";uptime ;echo ""
# NOTES
#######################################################
 
# To temporarily bypass an alias, we preceed the command with a \  
# EG:  the ls command is aliased, but to use the normal ls command you would
# type \ls
 
#################
### FUNCTIONS ###
#################
 
function    ff               { find . -name $@ -print; }
function    psa              { ps aux $@; }
function    psu              { ps  ux $@; }
function    dub              { du -sh $@; }
function    dir_size         { du-s2 $@|head -20; }
 
function    dfk              { df -kh $@; }
#function    lx              {ls -lAtrh $@|perl -pale '$_="@F[4,8,5..7]"'; }
# SPECIAL FUNCTIONS
#######################################################

#bu - Back Up a file. Usage "bu filename.txt"
bu () { cp $1 ${1}-`date +%Y%m%d%H%M`.backup ; }


PS1='\[\e[1;31m\][\T]\[\e]0;\w\a\]\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$'
PS1='\[\e[0;36m\]┌─\[\e[1;37m\][\u@\h]\[\e[0m\]\[\e[0;36m\]─\[\e[0;93m\](\w) \[\e[1;32m\][\A]\[\e[0m\]\n\[\e[0;36m\]└─\[$(tput bold)\] \[\e[1;31m\]→ \[\e[1;32m\] milla-tutorial\$ '
#PS1='\[\e[0;36m\]┌─\[\e[1;37m\][\u@\h]\[\e[0m\]\[\e[0;36m\]─\[\e[0;93m\](\w) \[\e[1;32m\][\A]\[\e[0m\]\n\[\e[0;36m\]└─\[$(tput bold)\]\[\e[1;31m\]→ \[\e[1;32m\] milla-tutorial\$ '





function mkcd() {
  [ -n "$1" ] && mkdir -p "$@" && cd "$1";
}

virc() { vim ~/.bashrc; . ~/.bashrc; }
cx() { chmod +x $*; }

get_source () { find -name "*.${1}" -print0 | xargs -0 grep -n "${2}" ; }


# Perl
tidy_file () { perltidy $1; mv $1.tdy $1 ; }


g_mine () 
{ 
    find -print0 | xargs -0 grep -n "${1}"
    #find ! -name '*html*' -print0 | xargs -0 grep -n "${1}"
}


export EDITOR=vim

export TERM=xterm-256color


# rewrite_commit_date(commit, date_timestamp)
#
# !! Commit has to be on the current branch, and only on the current branch !!
# 
# Usage example:
#
# 1. Set commit 0c935403 date to now:
#
#   rewrite_commit_date 0c935403
#
# 2. Set commit 0c935403 date to 1402221655:
#
#   rewrite_commit_date 0c935403 1402221655
#
rewrite_commit_date () {
    local commit="$1" date_timestamp="$2"
    local date temp_branch="temp-rebasing-branch"
    local current_branch="$(git rev-parse --abbrev-ref HEAD)"

    if [[ -z "$commit" ]]; then
        date="$(date -R)"
    else
        date="$(date -R --date "@$date_timestamp")"
    fi

    git checkout -b "$temp_branch" "$commit"
    GIT_COMMITTER_DATE="$date" git commit --amend --date "$date"
    git checkout "$current_branch"
    git rebase "$commit" --onto "$temp_branch"
    git branch -d "$temp_branch"
}


#function _update_ps1() {
#       export PS1="$(~/powerline-shell.py $? 2> /dev/null)"
#}

#export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"

[[ "$PS1" ]] && /usr/games/fortune | /usr/games/cowsay -n
