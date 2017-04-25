#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && "$f"
  done
  unset f
fi

/usr/bin/xdg-user-dirs-update &
setxkbmap -option terminate:ctrl_alt_bksp &
xbacklight -set 20
xsetroot -cursor_name left_ptr &
xset r rate 250 25 &
xset dpms 6000 6001 6002 &
xset s off &
numlockx &
urxvtd -q -f -o &
wmname XMonad &
mkfifo /tmp/pipe &
feh --bg-fill ~/Pictures/Wallpapers/wallpaper-035.png &
udiskie -2 -s &

exec xmonad
