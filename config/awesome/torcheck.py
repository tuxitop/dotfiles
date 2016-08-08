#! /usr/bin/python

from subprocess import Popen, PIPE

o = Popen(["systemctl", "status", "tor"], stdout=PIPE)
output = o.communicate()
status = output[0].decode("utf-8")
laststatus = status.splitlines()[-1]
if "active (running)" in status:
    if "100%" in laststatus or "new bridge" in laststatus:
        print("<span color=\"#7F9F7F\">Tor</span>")
    else:
        print("No connection")
else:
    print("inactive")
