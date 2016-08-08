# ~/.zshrc.local
# Customizations to zshell. based on grml-zsh-config
#
# Author: Ali Mousavi
# Last Updated: 2014/08/20
#
# Requirements:
# zsh
# grml-zsh-config
# htop
# pkgfile (for command not found hook in Arch Linux)

#----------------------------------------------------------------------
#  CUSTOM ALIASES
#----------------------------------------------------------------------

# Modified Commands:
alias grep='grep --color=auto'   # Colorful grep
alias df='df -h'                 # Human readable size
alias du='du -c -h'              # Human readable size and calculate grand total
alias mkdir='mkdir -v'           # Verbose mode
alias tmux='tmux -2'             # Enables 256 Colors in tmux

# New Commands
alias pi='ping 8.8.4.4'          # Ping Google's DNS
alias top='htop'                 # Use htop instead of top (needs htop package)
alias du1='du --max-depth=1'     # Compute size of current directory.
alias ducks='du -cks * | sort -rn | head -20' # 20 largest files & Dirs
alias retor='sudo systemctl restart tor' # Restart tor via systemd.
alias awrc='vim ~/.config/awesome/rc.lua'
alias aria2rpc='ruby /usr/share/doc/aria2/xmlrpc/aria2rpc'

# Privileged Access:
alias svim='sudo vim'
alias root='sudo su'
alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias pacman='sudo pacman'

# Safety is best
alias cp='cp -i'                 # Prompts before overwriting a file.
alias mv='mv -i'                 # Prompts before overwriting a file.
alias rm='rm -I'                 # Asks before deleting (-i ask for every file)
alias ln='ln -i'                 # Prompts before overwriting a file.
alias chown='chown --preserve-root' # Don't operate recursively on "/"
alias chmod='chmod --preserve-root' # Don't operate recursively on "/"
alias chgrp='chgrp --preserve-root' # Don't operate recursively on "/"


#----------------------------------------------------------------------
#  ENVIRONMENT VARAIBLES
#----------------------------------------------------------------------

export PATH=$PATH:$HOME/bin         # add directory for personal scripts
export EDITOR=vim                   # Define default editor
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on' # Better fonts in java apps
export QT_STYLE_OVERRIDE='GTK+'     # QT5 Style
export PATH=$PATH:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:/opt/android-sdk/build-tools               # Add android sdk to path
#export LC_TIME="en_US.utf8" # Gnome shows dates in persian. this should fix it.

## GRML Specific Variables:
#export COMMAND_NOT_FOUND=1
#export GRML_ZSH_CNF_HANDLER="/usr/share/doc/pkgfile/command-not-found.zsh"

#----------------------------------------------------------------------
#   PROMPT
#----------------------------------------------------------------------

# set the prompt theme
prompt grml-large

#----------------------------------------------------------------------
#  HOOKS
#----------------------------------------------------------------------
# Command not found hook for Arch Linux (requires pkg-file)
source /usr/share/doc/pkgfile/command-not-found.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#----------------------------------------------------------------------
#  FUNCTIONS
#----------------------------------------------------------------------

# Colorful less output for viewing man pages:
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


#Virtualenv support
function virtual_env_prompt () {
   REPLY=${VIRTUAL_ENV+(${VIRTUAL_ENV:t}) }
}
grml_theme_add_token  virtual-env -f virtual_env_prompt '%F{magenta}' '%f'
zstyle ':prompt:grml:left:setup' items rc virtual-env change-root user at host path vcs percent


