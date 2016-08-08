"""
Display the current keyboard layout using kbdd

Display the current keyboard layout using dbus and kbdd
kbdd is an XKB daemon to make per window keyboard layout.
Requirements:
- python-dbus
- kbdd (https://github.com/qnikst/kbdd)

Configuration parameters:
    - cache_timeout : how often we refresh this module in seconds

@author Ali Mousavi tuxitop@riseup.net
@license BSD
"""
from syslog import syslog, LOG_INFO
from time import time
import re
from dbus.mainloop.glib import DBusGMainLoop
import dbus


def log(msg):
    syslog(LOG_INFO, "keyboard_kbdd: %s" % msg[:100])


class Py3status:
    """
    """
    # available configuration parameters
    cache_timeout = 10
    configured_layouts = ['us', 'ir']

    def __init__(self):
        self._init_dbus()
        self._keyboard = self.configured_layouts[0]

    def _init_dbus(self):
        dbus_loop = DBusGMainLoop()
        bus = dbus.SessionBus(mainloop=dbus_loop)
        bus.add_signal_receiver(self._layout_changed,
                                dbus_interface='ru.gentoo.kbdd',
                                signal_name='layoutChanged')

    def _layout_changed(self, layout_changed):
        """
        Hanldler for "layoutChanged" dbus signal.
        """
        if self.colours:
            self._set_colour(layout_changed)
        self._keyboard = self.configured_layouts[layout_changed]

    def keyboard_layout(self, i3s_output_list, i3s_config):
        response = {
            'cached_until': time() + self.cache_timeout,
            'full_text': ''
        }
        response['full_text'] = self._keyboard
        return response


if __name__ == "__main__":
    """
    Test this module by calling it directly.
    This SHOULD work before contributing your module please.
    """
    from time import sleep
    x = Py3status()
    config = {
        'color_bad': '#FF0000',
        'color_degraded': '#FFFF00',
        'color_good': '#00FF00'
    }
    while True:
        print(x.keyboard_layout([], config))
        sleep(1)
