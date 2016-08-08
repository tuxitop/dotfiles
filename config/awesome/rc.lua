-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Dynamic Tagging --
local eminent = require("eminent")
-- Other Libraries
local vicious = require("vicious")
local volume = require("volume")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.init("/home/ali/.config/awesome/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = "gedit" -- os.getenv("EDITOR") or "nano"
editor_cmd = editor -- terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,        --1
    awful.layout.suit.tile,            --2
    awful.layout.suit.tile.left,       --3
    awful.layout.suit.tile.bottom,     --4
    awful.layout.suit.tile.top,        --5
    awful.layout.suit.fair,            --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.max,             --8
    awful.layout.suit.max.fullscreen,  --9
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
   names  = { "1:term", "2:www", "3:im", "4:fm", "5:devel", 6, 7, 8, 9 },
   layout = { layouts[8], layouts[8], layouts[8], layouts[8], layouts[6], layouts[7], layouts[1], layouts[1], layouts[3]
 }}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

netMenu = {
   { "chromium", "chromium"},
   { "thunderbird", "thunderbird"},
   { "xchat", "xchat" },
   { "telegram", "telegram" },
   { "deluge", "deluge-gtk" },
   { "uget", "uget-gtk" },
   { "hotot", "hotot-gtk3"},
}

toolsMenu = {
   { "gedit", "gedit" },
   { "goldendict", "goldendict" },
   { "longman", "aoss /home/ali/ldoce5/ldoce5" },
   { "puddletag", "puddletag" },
   { "kid3", "kid3-qt" },
   { "limoo", "limoo" },
   { "smplayer", "smplayer" },
   { "calcultor", "gcalctool" },
   { "gparted", "gparted" },
}

develMenu = {
   { "emacs", "emacs" },
   { "eclipse", "eclipse" },
   { "geany", "geany" },
   { "idle2", "idle2" }
}


officeMenu = {
   { "writer", "libreoffice --writer" },
   { "impress", "libreoffice --impress" },
   { "gimp", "gimp" },
   { "calc", "libreoffice --calc" },
   { "draw", "libreoffice --draw" },
   { "math", "libreoffice --math" }
}

gamesMenu = {
   { "pysol", "pysol" },
   { "Battle for Wesnoth", "wesnoth" }
   }

configMenu = {
   { "aRandR", "arandr" },
   { "lxappearance", "lxappearance" },
   { "qtconfig", "qtconfig" }
}

shutdownMenu = {
   { "restart wm", awesome.restart },
   { "quit wm", awesome.quit },
   { "halt", "systemctl poweroff" },
   { "reboot", "systemctl reboot" },
   { "suspend", "systemctl suspend"},
   { "hibernate", "systemctl hibernate"}
}

mymainmenu = awful.menu({ items = { { "browser", "firefox" },
                                   { "file manager", "spacefm" },
                                   { "terminal", terminal },
                                   { "net", netMenu },
                                   { "devel", develMenu },
                                   { "tools", toolsMenu },
                                   { "office", officeMenu },
                                   { "games", gamesMenu },
                                   { "config", configMenu },
                                   { "shutdown", shutdownMenu }
                                 }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.arch_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Autostart

function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

-- run_once("xscreensaver","-no-splash")
-- run_once("mpd")
-- run_once("mpdscribble", ">& /dev/null" )
run_once("setxkbmap", "-layout 'us,ir' -option grp:alt_shift_toggle,compose:ralt" )
run_once("kbdd" )
run_once("parcellite" )

-- }}}
-- {{{ Wibox

-- {{ My Widgets

separator = wibox.widget.textbox()
separator:set_text(" | ")
spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- Keyboard Layout Widget
kbdwidget = wibox.widget.textbox()
kbd_dbus_next = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.prev_layout"
kbd_dbus_set = "dbus-send --dest=ru.gentoo.KbddService /ru/gentoo/KbddService ru.gentoo.kbdd.set_layout"
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    lts = {[0] = "us", [1] = "ir"}
    kbdwidget:set_text (" "..lts[layout].." ")
    end)
os.execute(kbd_dbus_next)
os.execute(kbd_dbus_set .. "uint32:0")

-- Battery Widget
batwidget = wibox.widget.textbox()
baticon = wibox.widget.imagebox()
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args[1] == "-" then
            baticon:set_image(beautiful.widget_bat)
            if args[2] <= 40 then
                baticon:set_image(beautiful.widget_batempty)
            end
        else
            baticon:set_image(beautiful.widget_batcharging)
        end
        return args[2] .. "%"
    end, 30, "BAT0")

-- Volume Widget Mouse Bindings
volume_widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn("amixer set Master toggle",false) end),
   awful.button({ }, 4, function () awful.util.spawn("amixer set Master 5%+", false) end),
   awful.button({ }, 5, function () awful.util.spawn("amixer set Master 5%-", false) end)
 ))
-- Volume Widget Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

-- File System Usage Widget
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
fs = {
  r = awful.widget.progressbar(), h = awful.widget.progressbar()
}

for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(18):set_width(7):set_ticks_size(2)
  w:set_background_color('#494B4F')
  w:set_color('#AECF96')
  w:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"},
                      {1, "#FF5656"}}})
end
  fs_t = awful.tooltip({ objects = { fs.r, fs.h, fsicon }})
-- Register File System Widget
vicious.cache(vicious.widgets.fs)
vicious.register(fs.r, vicious.widgets.fs,
                 function (widget, args)
                     fs_t:set_text("root: " .. args["{/ used_gb}"] .. "GB/" .. args["{/ size_gb}"] .. "GB (" .. args["{/ used_p}"] .. "%)\n/home: " .. args["{/home used_gb}"] .. "GB/" .. args["{/home size_gb}"] .. "GB (" .. args["{/home used_p}"] .. "%)")
                     return args["{/ used_p}"]
                 end, 599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)

-- Memory Usage Widget
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = awful.widget.progressbar()
memwidget:set_width(8)
memwidget:set_height(10)
memwidget:set_vertical(true)
memwidget:set_background_color("#494B4F")
memwidget:set_border_color(nil)
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"},
                    {1, "#FF5656"}}})
-- RAM usage tooltip
memwidget_t = awful.tooltip({ objects = { memwidget, memicon },})
-- Register Widget
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem,
                function (widget, args)
                    memwidget_t:set_text(" RAM: " .. args[2] .. "MB / " .. args[3] .. "MB ")
                    return args[1]
                 end, 13)
                 --update every 13 seconds

-- CPU usage widget
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = awful.widget.graph()
cpuwidget:set_width(18)
cpuwidget:set_height(18)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#FF5656"}, {0.5, "#88A175"},
                    {1, "#AECF96" }}})
cpuwidget_t = awful.tooltip({ objects = { cpuwidget, cpuicon },})
-- Register CPU widget
vicious.register(cpuwidget, vicious.widgets.cpu,
                function (widget, args)
                    cpuwidget_t:set_text("CPU1: " .. args[2] .. "%" .. "\nCPU2: " .. args[3] .. "%" .. "\nTotal: " .. args[1] .. "%")
                    return args[1]
                end)

-- Jalali Date Widget
-- Initialize
function jdateupdate ()
    local fd = io.popen("jdate +%E | sed 's/\\(.*ه\\)\\( \\)\\(.*\\)،.*/\\1، \\3/'")
    local jnow = fd:read("*all")
    fd:close()
    jdatewidget:set_text(jnow)
    jdatewidget:set_font('Iranian Sans 9')
end
-- Widget
jdatewidget = wibox.widget.textbox()
jdateupdate()
-- Timer to check the date
jdatetimer = timer({ timeout = 60 })
jdatetimer:connect_signal("timeout", function() jdateupdate() end)
jdatetimer:start()

-- Wifi Widget
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi, "${linp}% - ${ssid}", 5, "wlan0")
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)

-- Widget for Tor status.
function torStatUpdate()
    local command = io.popen("python3 /home/ali/.config/awesome/torcheck.py")
    local torstat = command:read("*all")
    command:close()
    torwidget:set_markup(torstat)
end

torwidget = wibox.widget.textbox()
torStatUpdate()

-- Timer for the widget
tortimer = timer({timeout = 15})
tortimer:connect_signal("timeout", function() torStatUpdate() end)
tortimer:start()


-- Network usage wiget
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, '<span color="#CC9393">${wlan0 down_kb}</span> <span color="#7F9F7F">${wlan0 up_kb}</span>', 3)
dnicon = wibox.widget.imagebox()
upicon =  wibox.widget.imagebox()
dnicon:set_image(beautiful.widget_netdown)
upicon:set_image(beautiful.widget_netup)

-- Uptime widget
uptimewidget = wibox.widget.textbox()
  vicious.register(uptimewidget, vicious.widgets.uptime,
    function (widget, args)
      return string.format(", Uptime: %2dd %02d:%02d ", args[1], args[2], args[3])
    end, 61)

-- Pacman Widget
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_arch)
pacwidget = wibox.widget.textbox()
pacwidget_t = awful.tooltip({ objects = { pacwidget },})
vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("pacman -Qu")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    pacwidget_t:set_text(str)
                    s:close()
                    return "Updates: " .. args[1]
                end, 1800, "Arch")
                --'1800' means check every 30 minutes

-- MPD Widget
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then
            return " Stopped "
        elseif args["{state}"] == "Play" then
            return " Now Playing:  " ..args["{Artist}"]..' - '.. args["{Title}"]
        elseif args["{state}"] == "Pause" then
            return " Paused:  " ..args["{Artist}"]..' - '.. args["{Title}"]
        else
            return " - "
        end
    end, 10)
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_music)


--}}

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Top Bar {{{
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left (Top Bar)
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right (Top Bar)
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(separator)
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(fsicon)
    right_layout:add(fs.h)
    right_layout:add(spacer)
    right_layout:add(fs.r)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(volicon)
    right_layout:add(volume_widget)
    right_layout:add(separator)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(kbdwidget)
    right_layout:add(separator)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle) (Top Bar)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    -- }}}

    -- Bottom Bar {{{
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })

    -- Left aigned widgets(Bottom Bar)
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mpdicon)
--    left_layout:add(mpdwidget)

    -- Right aligned widgets (Bottom Bar)
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(separator)
    right_layout:add(pacicon)
    right_layout:add(pacwidget)
    right_layout:add(uptimewidget)
    right_layout:add(separator)
    right_layout:add(dnicon)
    right_layout:add(netwidget)
    right_layout:add(upicon)
    right_layout:add(separator)
    right_layout:add(torwidget)
    right_layout:add(separator)
    right_layout:add(wifiicon)
    right_layout:add(wifi)
    right_layout:add(separator)
    right_layout:add(jdatewidget)

    -- Now bring it all together (Bottom Bar)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    -- }}}
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- My Keybindings
    awful.key({ }, "XF86AudioRaiseVolume", function ()
       awful.util.spawn("amixer set Master 5%+") end),
    awful.key({ }, "XF86AudioLowerVolume", function ()
       awful.util.spawn("amixer set Master 5%-") end),
    awful.key({ }, "XF86AudioMute", function ()
       awful.util.spawn("amixer sset Master toggle") end),
    awful.key({ }, "XF86AudioPrev", function ()
       awful.util.spawn("mpc prev") end),
    awful.key({ }, "XF86AudioPlay", function ()
       awful.util.spawn("mpc toggle") end),
    awful.key({ }, "XF86AudioNext", function ()
       awful.util.spawn("mpc next") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons,
                     size_hints_honor = false} },
    -- Floating Apps
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true} },
    { rule = { class = "smplayer" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { name = "File Operation Progress" },
      properties = { floating = true } },
    { rule = { class= "Spacefm", name = "Find Files" },
      properties = { floating = true } },
    { rule = { class= "Spacefm", name = "Done" },
      properties = { floating = true } },
    { rule = { class= "File-roller" },
      properties = { floating = true } },

    -- Tag Specific Apps
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Firefox", name = "Library" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", name = "Firefox Preferences" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "Browser" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "Global" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "StylishEdit*" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "DTA" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "Toplevel" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "Foxyproxy-options" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Firefox", instance = "Netvideohunter" },
      properties = { floating = true, tag = tags[1][2] } },
    { rule = { class = "Deluge" },
      properties = { floating = true, tag = tags[1][8] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][2] } },
    { rule = { class= "Hexchat" },
      properties = { tag = tags[1][3] } },
    { rule = { class= "Telegram" },
      properties = { tag = tags[1][3] } },
    { rule = { class= "Spacefm" },
      properties = { tag = tags[1][4] } },
    { rule = { class= "Clementine`" },
      properties = { tag = tags[1][4] } },
    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][5] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
