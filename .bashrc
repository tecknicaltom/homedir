# /etc/skel/.bashrc:
# $Header: /home/cvsroot/gentoo-src/rc-scripts/etc/skel/.bashrc,v 1.8 2003/02/28 15:45:35 azarah Exp $

# This file is sourced by all *interactive* bash shells on startup.  This
# file *should generate no output* or it will break the scp and rcp commands.

# colors for ls, etc.
eval `dircolors -b /etc/DIR_COLORS`
alias ls="ls -F --color=auto"
alias ll="ls -F --color -lh"
alias rip="rip -SOTcn -f '%A - %T - %N - %S'"
alias new="ls -t | head -1"
alias lock="xscreensaver-command -lock"
alias externIp="wget --quiet --output-document\=- ip.modtwo.com"
alias cp="cp -i"
alias mv="mv -i"
alias printCode="enscript -T 4 -r2GC -E -DDuplex:true "
function mkcd {
	mkdir -p "$1" && cd "$1"
}

export PATH=~/bin/:$PATH
export HISTIGNORE="&:ls:[bf]g:exit"
export LESSCHARSET="utf-8"
COLOR_ERROR='1;31'
PWDMAXLENGTH=30
PROMPTTRUNCSYM="..."

# Make terminal-specific changges
case $TERM in
  xterm*|rxvt|Eterm|eterm|rxvt-unicode)
    PROMPT_COMMAND_TITLE="\033]0;USER@HOSTNAME:CURRDIR\007"
    export LC_ALL="en_US.UTF-8"
    ;;
  rxvt-cygwin-native)
    PROMPT_COMMAND_TITLE="\033]0;USER@HOSTNAME:CURRDIR\007"
    export LC_ALL="C"
    ;;
  screen)
    PROMPT_COMMAND_TITLE='\033_USER@HOSTNAME:CURRDIR\033\\'
    export LC_ALL="en_US.UTF-8"
    ;;
  linux)
    export LC_ALL="en_US.UTF-8"
    ;;
  *)
    export LC_ALL="POSIX"
    ;;
esac

PROMPT_COMMAND=promptcommand
function promptcommand {
  TMPSTAT=$?
  TMPTITLE=${PROMPT_COMMAND_TITLE/USER/$USER}
  TMPHOST=${HOSTNAME%%.*}
  TMPTITLE=${TMPTITLE/HOSTNAME/$TMPHOST}
  TMPDIR=${PWD/$HOME/\~}
  TMPTITLE=${TMPTITLE/CURRDIR/$TMPDIR}
  echo -ne $TMPTITLE

  if [ ${#TMPDIR} -gt $PWDMAXLENGTH ]
  then
    PWDOFFSET=$(( ${#TMPDIR} - $PWDMAXLENGTH + ${#PROMPTTRUNCSYM} ))
    TMPDIR="${PROMPTTRUNCSYM}${TMPDIR:$PWDOFFSET:$PWDMAXLENGTH}"
  fi


  if [ $TMPSTAT -gt 0 ]
  then
    PS1="[\[\033[0;34m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\]:\[\033[\${COLOR_ERROR}m\]\$TMPSTAT\[\033[0m\]:\[\033[0;32m\]$TMPDIR\[\033[0m\]] "
  else
    PS1="[\[\033[0;34m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\]:\[\033[0;32m\]$TMPDIR\[\033[0m\]] "
  fi

  unset TMPTITLE
  unset TMPDIR
  unset TMPHOST
#  unset TMPSTAT
}

##uncomment the following to activate bash-completion:
[ -f /etc/profile.d/bash-completion.sh ] && source /etc/profile.d/bash-completion.sh
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion

case $HOSTNAME in
	tomslappy)
		# home machine
		;;
	flexo)
		# work linux machine
		;;
	toms)
		# work windows machine
		export PRINTER='HP LaserJet 4000 Series'
		alias bzr="/c/Python25/python.exe 'c:\Python25\Scripts\bzr' "
		[ -f /etc/bash_completion ] && source /etc/bash_completion
		cd
		;;
esac
