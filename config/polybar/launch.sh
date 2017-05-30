#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
MONITOR="LVDS1" TRAY="right" polybar top &
MONITOR="VGA1" polybar top &
MONITOR="HDMI1" polybar top &
MONITOR="LVDS1" polybar bottom &
MONITOR="VGA1" polybar bottom &
MONITOR="HDMI1" polybar bottom &

echo "Bars launched..."
