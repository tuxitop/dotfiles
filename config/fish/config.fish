# ~/.config/fish/config.fish
# Customizations to fish config
#
# Author: Ali Mousavi
# Last Updated: 2015-10-26
#
# Requirements:
# fish

#------------------------------------------------------------
# Aliases
#------------------------------------------------------------

# Modifications
alias grep='grep --color=auto'   # Colorful grep
alias df='df -h'                 # Human readable size
alias du='du -c -h'              # Human readable size and calculate grand total
alias mkdir='mkdir -v'           # Verbose mode
alias tmux='tmux -2'             # Enables 256 Colors in tmux

# New commands
alias pi='ping 8.8.4.4'          # Ping Google's DNS
alias top='htop'                 # Use htop instead of top (needs htop package)
alias du1='du --max-depth=1'     # Compute size of current directory.
alias ducks='du -cks * | sort -rn | head -20' # 20 largest files & Dirs
alias retor='sudo systemctl restart tor' # Restart tor via systemd.

# Privileged Access:
alias svim='sudo vim'
alias root='sudo su'
alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias pacman='sudo pacman'

# Safty
alias cp='cp -i'                 # Prompts before overwriting a file.
alias mv='mv -i'                 # Prompts before overwriting a file.
alias rm='rm -I'                 # Asks before deleting (-i ask for every file)
alias ln='ln -i'                 # Prompts before overwriting a file.
alias chown='chown --preserve-root' # Don't operate recursively on "/"
alias chmod='chmod --preserve-root' # Don't operate recursively on "/"
alias chgrp='chgrp --preserve-root' # Don't operate recursively on "/"

#------------------------------------------------------------
# Custom Functions
#------------------------------------------------------------

# History Substitution: https://gist.github.com/b-/981892a65837ab0a387e
# Syntax:
# To just rerun your last command, simply type '!!'
# This forked version supports "sudo !!" via two functions.
function !!
    eval $history[1] $argv
end function
function sudo
    if test $argv[1]
        if test $argv[1] = "!!"
            eval /usr/bin/sudo $history[1]
        else
            eval /usr/bin/sudo $argv
        end
    end
end

#------------------------------------------------------------
# Prompt
#------------------------------------------------------------
# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
#set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'
function fish_prompt
  set last_status $status

  set_color yellow
  printf '%s' (whoami)
  set_color normal
  printf '@'
  set_color magenta
  printf '%s ' (hostname|cut -d . -f 1)
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s > ' (__fish_git_prompt)

  set_color normal
end

#------------------------------------------------------------
# Intro Message
#------------------------------------------------------------

function fish_greeting
  fortune -c | cowthink -f (find /usr/share/cows -type f | shuf -n 1)
  figlet -cf slant "TUXITOP"
end