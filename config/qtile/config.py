# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
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

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
import subprocess
import re
from threading import Thread
import tuxitile
import signal


# This is to prevent zombie processes. experimental workaround found in
# https://stackoverflow.com/questions/16807603/python-non-blocking-non-defunct-process
signal.signal(signal.SIGCHLD, signal.SIG_IGN)


class Theme(object):
    bar = {
        'size': 20,
        'background': '4A3A47',
    }
    groupbox = {
        'borderwidth': 2,
        'padding': 3.2,
        'margin': 0,
        'inactive': "FFFFFF",
        'active': "E6F0AF",
        'highlight_method': "block",
        'urgent_alert_method': "block"
    }
    sep = {
        'height_percent': 60,
        'foreground': 'D7E8D5'
    }
    volume = {
        # 'font': 'DroidSans',
        'emoji': False,
        'mute_command': 'amixer -q -D pulse set Master toggle'.split(),
        'volume_up_command': 'amixer -q -D pulse set Master 2%+'.split(),
        'volume_down_command': 'amixer -q -D pulse set Master 2%-'.split(),
        'get_volume_command': 'amixer -D pulse get Master'.split(),
    }
    TaskList = {
        'highlight_method': 'block',
        'urgent_alert_method': "block",
        'margin': 0,
        'padding': 3.2
    }


mod = "mod4"

keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.down()
    ),
    Key(
        [mod], "j",
        lazy.layout.up()
    ),

    # Move windows up or down in current stack
    Key(
        [mod, "control"], "k",
        lazy.layout.shuffle_down()
    ),
    Key(
        [mod, "control"], "j",
        lazy.layout.shuffle_up()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.layout.rotate()
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),
    Key([mod], "Return", lazy.spawn("xterm")),

    # Toggle between different layouts as defined below
    Key([mod], "j", lazy.next_layout()),

    Key([mod, "shift"], "c", lazy.window.kill()),

    Key([mod], "f", lazy.window.toggle_floating()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    # Lock the screen
    Key([mod], "s", lazy.spawn("rofi-pass")),


    Key([mod], "l", lazy.spawn("i3lock -c100030")),

    # Multimedia Keys
    Key([], "XF86AudioPlay",
        lazy.spawn("dbus-send --print-reply\
                    --dest=org.mpris.MediaPlayer2.spotify\
                    /org/mpris/MediaPlayer2\
                    org.mpris.MediaPlayer2.Player.PlayPause")),
    Key([], "XF86AudioNext",
        lazy.spawn("dbus-send --print-reply\
                    --dest=org.mpris.MediaPlayer2.spotify\
                    /org/mpris/MediaPlayer2\
                    org.mpris.MediaPlayer2.Player.Next")),
    Key([], "XF86AudioPrev",
        lazy.spawn("dbus-send --print-reply\
                    --dest=org.mpris.MediaPlayer2.spotify\
                    /org/mpris/MediaPlayer2\
                    org.mpris.MediaPlayer2.Player.Previous")),
    Key([], "XF86AudioMute",
        lazy.spawn("amixer -q -D pulse set Master toggle")),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("amixer -q -D pulse set Master 2%+")),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("amixer -q -D pulse set Master 2%-")),
]

groups = [Group("term"),
          Group("www", matches=[Match(wm_class=["Google-chrome",
                                                "Thunderbird"
                                                ])]),
          Group("im", matches=[Match(wm_class=["Telegram",
                                               "Hexchat",
                                               "Viber"
                                               ])]),
          Group("fm"),
          Group("devel"),
          Group("6"),
          Group("7"),
          Group("8"),
          Group("9")
          ]


for i in range(9):
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], str(i + 1), lazy.group[groups[i].name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], str(i + 1), lazy.window.togroup(groups[i].name))
    )

layouts = [
    layout.Max(),
    layout.Stack(num_stacks=2),
    layout.Floating()
]

widget_defaults = dict(
    font='Helvatica',
    fontsize=12,
    padding=2,
)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(**Theme.groupbox),
                widget.Prompt(),
                widget.TaskList(**Theme.TaskList),
                # widget.Notify(default_timeout=5),
                widget.Sep(**Theme.sep),
                widget.Systray(),
                widget.Sep(**Theme.sep),
                tuxitile.KeyboardKbdd(),
                widget.Sep(**Theme.sep),
                widget.Volume(**Theme.volume),
                widget.Sep(**Theme.sep),
                widget.Clock(format='%a %b %d, %H:%M'),
            ], **Theme.bar),
        bottom=bar.Bar(
            [
                widget.Mpris2(name="spotify",
                              objname='org.mpris.MediaPlayer2.spotify',
                              scroll_chars=None,
                              display_metadata=['xesam:title',
                                                'xesam:artist'
                                                ]
                              ),
                widget.Spacer(),
                widget.Sep(),
                widget.TextBox('updates:', name='pacman'),
                widget.CheckUpdates(),
                widget.Sep(),
                widget.Net(),
                widget.Sep(),
                # widget.Wlan(),
            ], **Theme.bar),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(**Theme.groupbox),
                widget.Prompt(),
                widget.TaskList(**Theme.TaskList),
                # widget.Notify(default_timeout=5),
                widget.Sep(**Theme.sep),
                tuxitile.KeyboardKbdd(),
                widget.Sep(**Theme.sep),
                widget.Volume(**Theme.volume),
                widget.Sep(**Theme.sep),
                widget.Clock(format='%a %b %d, %H:%M'),
            ], **Theme.bar),
        bottom=bar.Bar(
            [
                widget.Mpris2(name="spotify",
                              objname='org.mpris.MediaPlayer2.spotify',
                              scroll_chars=None,
                              display_metadata=['xesam:title',
                                                'xesam:artist'
                                                ]
                              ),
                widget.Spacer(),
                widget.Sep(),
                widget.Net(),
            ], **Theme.bar),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True


# restart in case of new monitor.
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    qtile.cmd_restart()


float_windows = set([
                    "feh",
                    'wine'
                    ])


# TODO: Make it more convenient:
def should_be_floating(w):
    wm_class = w.get_wm_class()
    if wm_class is None:
        return True
    if isinstance(wm_class, tuple):
        for cls in wm_class:
            if cls.lower() in float_windows:
                return True
    else:
        if wm_class.lower() in float_windows:
            return True
    return w.get_wm_type() == 'dialog' or bool(w.get_wm_transient_for()) or\
        w.get_wm_window_role() == 'pop-up'  # <- this is for chromium pop-ups


@hook.subscribe.client_new
def dialogs(window):
    if should_be_floating(window.window):
        window.floating = True


def is_connected_to_home():
    # requires wireless tools.
    '''checks if i am connected to my home wireless,
    I want to start some programs later if connected.'''
    process = subprocess.Popen(['iwgetid', '-r'], stdout=subprocess.PIPE)
    ssid = process.communicate()[0].decode("utf-8").strip()
    if ssid == "theTerminal":
        return True
    return False


# I have used Threading for starting up apps because simply running the apps as
# a child, and not waiting for them to finish, will cause the init app in linux
# not to get it's return code if I kill/terminate the app. so the
# process wouldn't finish successfully and will stay in ps output as a
# <defunct> (zombie) process.
def is_running(process):
    process = process.split()[0]
    s = subprocess.Popen(["ps", "axw"], stdout=subprocess.PIPE)
    stdout = s.communicate()[0]
    if re.search(process, stdout.decode("utf-8")):
        return True
    return False


def execute_once(command):
    '''Takes a command and executes it if it's not running already.
       command can be a string or a tuple. if it is a tuple,
       the second element will be considered as it's process and the first
       element will be executed.
       eg:
       command = "udiskie -2"
       command = ("startup.sh", "tmux")
    '''
    if isinstance(command, tuple):
        process = command[1]
        command = command[0]
    else:
        process = command
    if not is_running(process):
        Thread(target=lambda: subprocess.check_call(command.split())).start()


def startup_apps():
    apps = (
        "parcellite",
        "feh --bg-fill\
            /home/ali/Pictures/Wallpapers/wallpaper625872.jpg",
        "xsetroot -cursor_name left_ptr",
        "setxkbmap \
            -layout 'us,ir' \
            -option grp:alt_shift_toggle, compose:ralt",
        "kbdd",
        "dunst",
        "udiskie -2 --tray",
        "qtile_startup.sh",
        "rofi &",
        "/home/ali/.config/qtile/locker.sh",
    )
    # These will run only if I'm home
    apps_if_home = (
        ("google-chrome-stable", "/opt/google/chrome/chrome"),
        "hexchat",
        "telegram"
    )
    for app in apps:
        execute_once(app)
    if is_connected_to_home():
        for app in apps_if_home:
            if isinstance(app, list):
                execute_once(app[0], app[2])
            execute_once(app)


@hook.subscribe.startup
def startup():
    Thread(target=startup_apps).start()


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
