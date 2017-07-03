# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Add to history instead of overriding it
shopt -s histappend

# History lenght
HISTSIZE=1000
HISTFILESIZE=2000

# Window size sanity check
shopt -s checkwinsize

# User/root variables definition
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Colored XTERM promp
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Colored prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Prompt
if [ -n "$SSH_CONNECTION" ]; then
export PS1="\[$(tput setaf 1)\]┌─╼ \[$(tput setaf 7)\][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼ \[$(tput setaf 7)\][ssh]\"; else echo \"\[$(tput setaf 1)\]└╼ \[$(tput setaf 7)\][ssh]\"; fi) \[$(tput setaf 7)\]"
else
export PS1="\[$(tput setaf 1)\]┌─╼ \[$(tput setaf 7)\][\w]\n\[$(tput setaf 1)\]\$(if [[ \$? == 0 ]]; then echo \"\[$(tput setaf 1)\]└────╼\"; else echo \"\[$(tput setaf 1)\]└╼\"; fi) \[$(tput setaf 7)\]"
fi

trap 'echo -ne "\e[0m"' DEBUG

# I this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Auto-completion 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Advanced directory creation
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Entrez un nom pour ce dossier"
  elif [ -d $1 ]; then
    echo "\`$1' existe déjà"
  else
    mkdir $1 && cd $1
  fi
}

# Go back with ..
b() {
    str=""
    count=0
    while [ "$count" -lt "$1" ];
    do
        str=$str"../"
        let count=count+1
    done
    cd $str
}

# Color man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

# Auto cd
shopt -s autocd

# ls after a cd
function cd()
{
 builtin cd "$*" && ls
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}


# Aliases files and directories
alias ls='ls -h --color=auto' 
alias ll='ls -l' 
alias la='ls -A' 
alias l='ls -CF' 
alias h='cd' 
alias ..='cd ..' 
alias ...='cd ../..'  
alias back='cd $OLDPWD' 


# Aliases system
alias addkey="gpg --keyserver pgp.mit.edu --recv-keys"
alias killx="kill -9 -1"
alias root='sudo su' 
alias runlevel='sudo /sbin/init' 
alias grep='grep --color=auto' 
alias dfh='df -h' 
alias gvim='gvim -geom 84x26' 
alias sx='startx' 
alias fd='sudo fdisk -l' 
alias lsblk='grc --colour=auto lsblk'
alias blk='sudo blkid' 
alias iw='iwconfig' 
alias ej='eject sr0' 
alias off='sudo shutdown -h now' 
alias logout='kill -9 -1' 
alias bleach='sudo bleachbit'  
alias fdisk='sudo fdisk -l' 
alias reboot='sudo reboot' 
alias all_formats='ffmpeg -formats 2> /dev/null'
alias grep='grep --color=auto'
alias psuser='ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command' # Shows user only processes


# Aliases systemd
alias senable='sudo systemctl enable'
alias srestart='sudo systemctl restart'
alias sstatus='sudo systemctl status'
alias sstop='sudo systemctl stop'
alias sstart='sudo systemctl start'
alias service='systemctl list-unit-files | grep enable'
alias offservice='systemctl list-unit-files | grep disable'


# Aliases network
alias wifi-list="netctl-auto list"
alias wifi='lspci -nnk | grep -A2 0280' # Shows WiFi info
alias netrestart='sudo systemctl restart netctl-auto@wlp2s0.service' # Restarts wifi network
alias netctlrestart='sudo systemctl restart netctl.service' # Restarts netctl servica


# Aliases pacman/yaourt
alias installed='pacman -Qen' #Shows packages installed
alias orphan='sudo pacman -Rns $(pacman -Qtdq)' # Removes orphaned packages 
alias upg='sudo pacman -Syuu' # Upgrades pacman packages
alias window='xwininfo'  # Shows active window info
alias yu='yaourt -Syuua' # Upgrades yaourt packages
alias uuid='ls /dev/disk/by-uuid -alh' # Shows HDD/SSD drives UUIDs
alias rm='timeout 4 rm -iv --one-file-system'  # Files delete confirmation request. Waits for a four seconds
alias proc='cat /proc/cpuinfo | grep "^model name" | uniq' # Shows cpu info
alias pacsearch="pacman -Sl | cut -d' ' -f2 | grep " # It allows you to search all available packages simply using 'pacsearch packagename':
alias pkglist="comm -13 <(pacman -Qmq | sort) <(pacman -Qqe | sort) > pkglist" # Create list of all installed packages
alias bck=" pacman -Q | awk '{print $1}' > package_list.txt"
alias pacup='sudo pacman -Syu' # Synchronises repositories and updates if you have any update
alias pacre='sudo pacman -Rns' # Remove a specific package and all its dependencies and configurations
alias pacorf='sudo pacman -Rns $(pacman -Qtdq)' # Create list of orphaned packages for removal
alias pacin='sudo pacman -S' # Install a specific package by pacman
alias yain='yaourt -S' # Install a specific package by yaourt


# Aliases scripts
alias info='Scripts/info'
alias color='Scripts/colors.sh'
alias speed='Scripts/speedtest-cli'


# Aliases vim
alias svim='sudo vim'


# Aliases vivaldi-snapshot
alias vivaldi-icon='sudo vim /opt/vivaldi-snapshot/resources/vivaldi/style/common.css'


# Aliases git
alias gitf='git add --all && git commit -m "Update" && git push'
alias gita='git add'
alias giti='git add -i'
alias gitc='git commit -m "Update"'
alias gitp='git push'
alias gits='git status'
alias gitl='git log'


# Aliases xmonad
alias xmonad_recompile='cd ~/.xmonad && rm -rf xmonad.errors && rm -rf xmonad.hi && rm -rf xmonad.o && ghc --make xmonad.hs -i -ilib -dynamic -fforce-recomp -main-is main -v0 -o xmonad-x86_64-linux && xmonad --restart && killall xmobar && xmobar'


# Several aliases
alias tmp='sudo mount -o remount,size=4G /tmp' 
alias website='wget --limit-rate=200k --no-clobber --convert-links --random-wait -r -p -E -e robots=off -U vivaldi'
alias msfconsole="msfconsole --quiet -x \"db_connect ${USER}@msf\""
alias broken="sudo find . -type l -! -exec test -e {} \; -print"
alias gpdf="wkhtmltopdf -s A4" 
alias less=$PAGER


# Exports
export PATH="/home/tozen/.bin:$PATH"
export PATH="/home/tozen/.local/bin:$PATH"
export LESS=-R export LESS_TERMCAP_mb=$'\E[1;31m' 
export LESS_TERMCAP_md=$'\E[1;36m' 
export LESS_TERMCAP_me=$'\E[0m' 
export LESS_TERMCAP_se=$'\E[0m' 
export LESS_TERMCAP_so=$'\E[01;44;33m' 
export LESS_TERMCAP_ue=$'\E[0m' 
export LESS_TERMCAP_us=$'\E[1;32m' 


# Launches screenfetch scrips to show system info
# screenfetch

