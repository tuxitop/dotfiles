#setxkbmap -layout 'us,ir' -option grp:alt_shift_toggle,compose:ralt
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
#kbdd
exec i3 -V >> ~/.cache/i3/i3log 2>&1
#dunst &
#exec qtile > ~/.cache/qtile/stdout 2> ~/.cache/qtile/stder
#exec x11trace /usr/bin/qtile > ~/.cache/qtile/xtrace.log
#exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
#exec gnome-session
