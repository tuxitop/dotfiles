#!/bin/bash

# Copyright (c) 2015 Ali Mousavi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


PS=$(ps aux)

# Start tmux if a tmux session (named qtile) and a termite process is not available.
if ! (tmux list-sessions 2>/dev/null | grep -q "^i3"); then
    termite -e "bash -c 'tmux new-session -s i3 -d; tmux split-window -h; tmux -2 attach-session -d'" 2>/dev/null 1>&2 &
fi;

# Start google-chrome if connected to Home Wireless.
# requires wireless_tools
SSID=$(iwgetid -r)
HOME_NET="theTerminal"
if [[ $SSID = $HOME_NET ]]; then
    if ! (echo $PS | grep -q firefox-developer ); then
        firefox-developer 2>/dev/null 1>&2 &
    fi;
    if ! (echo $PS | grep -q hexchat); then
        hexchat 2>/dev/null 1>&2 &
    fi
    if ! (echo $PS | grep -q telegram-deskto); then
        telegram-desktop 2>/dev/null 1>&2 &
    fi
fi;
