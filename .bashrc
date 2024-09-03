# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Source global definitions
if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

export LESS="-RSM~gIsw"
    #* R - Raw color codes in output (don't remove color codes)
    #* S - Don't wrap lines, just cut off too long text
    #* M - Long prompts ("Line X of Y")
    #* ~ - Don't show those weird ~ symbols on lines after EOF
    #* g - Highlight results when searching with slash key (/)
    #* I - Case insensitive search
    #* s - Squeeze empty lines to one
    #* w - Highlight first line after PgDn
export LESSOPEN="|lesspipe.sh %s"
export LESSCOLORIZER=pygmentize

alias vless='/usr/share/vim/vim??/macros/less.sh'

# KDE Plasma
alias open=kde-open5

# ToDo.txt
#alias t='~/bin/todo.txt_cli-2.??/todo.sh'
# git cloned version
alias t='~/git/todo.txt-cli/todo.sh'
#source ~/bin/todo.txt_cli-2.??/todo_completion
source ~/git/todo.txt-cli/todo_completion
complete -F _todo t

# colorize man pages
export MANPAGER="/usr/bin/most -s"

# --- GPG for SSH ---
# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
	gpg-connect-agent /bye >/dev/null 2>&1
fi
# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
	export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  fi
# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
# --- GPG for SSH ---


# https://www.ibm.com/developerworks/linux/library/l-tip-prompt/
# Prompt Magic
# where:
# Line 1-- current date and time
# Line 2-- current working directory
# Line 3-- username @ host: console number: # of files in directory total size of directory on disk ->
export PS1="
\[\033[35m\]\$(/bin/date +'%a %d %b %Y  %T %Z')
\[\033[32m\]\w\n\[\033[1;33m\]\u@\h\[\033[1;34m\] -> \[\033[0m\]"
#\[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"

# added by Anaconda3 4.2.0 installer
#export PATH="/home/mitch/anaconda3/bin:$PATH"
#
# Add Python bin directories to path
python3.6 -m site &> /dev/null && PATH="$PATH:`python3.6 -m site --user-base`/bin"
python2.7 -m site &> /dev/null && PATH="$PATH:`python2.7 -m site --user-base`/bin"

# Android Studio
export PATH="/opt/android-sdk/emulator:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:$PATH"
# https://developer.android.com/studio/command-line/variables
export ANDROID_SDK_ROOT=/opt/android-sdk/
export ANDROID_SDK_HOME=/opt/android-sdk/

# My own stuff:
export PATH="/home/mitch/bin:$PATH"

# Udacity ROS
export CMAKE_PREFIX_PATH=/usr
#export PYTHONPATH=/usr/lib64/python2.7/site-packages/
export ROS_DISTRO=kinetic
export ROS_ETC_DIR=/usr/etc/ros
export ROS_MASTER_URI='http://localhost:11311'
export ROS_PACKAGE_PATH=/usr/share/ros_packages
export ROS_ROOT=/usr/share/ros


# kdesrc-build #################################################################

## Add kdesrc-build to PATH
export PATH="$HOME/kde/src/kdesrc-build:$PATH"

## Autocomplete for kdesrc-run
function _comp-kdesrc-run
{
  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  # Complete only the first argument
  if [[ $COMP_CWORD != 1 ]]; then
    return 0
  fi

  # Retrieve build modules through kdesrc-run
  # If the exit status indicates failure, set the wordlist empty to avoid
  # unrelated messages.
  local modules
  if ! modules=$(kdesrc-run --list-installed);
  then
      modules=""
  fi

  # Return completions that match the current word
  COMPREPLY=( $(compgen -W "${modules}" -- "$cur") )

  return 0
}

## Register autocomplete function
complete -o nospace -F _comp-kdesrc-run kdesrc-run

################################################################################

# Node Version Manager for Node.js
# https://wiki.archlinux.org/title/node.js
# https://github.com/nvm-sh/nvm
source /usr/share/nvm/init-nvm.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To download, compile, and install the latest release of node, do this:
# nvm install node # "node" is an alias for the latest version

# keep dotfiles in git
# https://www.atlassian.com/git/tutorials/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
