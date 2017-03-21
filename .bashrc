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


# Put your fun stuff here.
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

# ToDo.txt
alias t='~/bin/todo.txt_cli-2.??/todo.sh'
source ~/bin/todo.txt_cli-2.??/todo_completion
complete -F _todo t

# colorize man pages
export MANPAGER="/usr/bin/most -s"


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
export PATH="/home/mitch/anaconda3/bin:$PATH"
