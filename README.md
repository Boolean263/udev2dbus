# udev2dbus

## What?

This is a simple script and udev rules that, when used together, generate dbus messages when a device is plugged in or unplugged.

## Why?

I wanted to run a script *in my X session* when a keyboard was attached. All the solutions I could find for this involved custom-built udev rules which need your username and display number hard-coded. This seemed ridiculous to me; there had to be a way to listen for udev events through dbus. I couldn't find such a thing, so I created one.

## How to install it?

* Put `99-udev2dbus.rules` in `/etc/udev/rules.d/`
* Put `udev2dbus.sh` in `/usr/local/bin/`

You will need root/sudo privileges to do both. On modern systems that's all there is to it. On older systems you may need to restart udev or your computer.

## How to use it?

Now, Whenever a device is added to or removed from your system, a dbus message will be generated. You don't need root in order to listen for these messages. You can watch for these messages with the `dbus-monitor` command:

```sh
dbus-monitor --system "interface='org.udev.event'"
```

Most programming and scripting languages nowadays can listen for and act on dbus messages. Here's a simple python example using [pydbus](https://github.com/LEW21/pydbus):

```python
#!/usr/bin/env python3

import os
import subprocess
import pydbus
from gi.repository import GLib


def handle_signal(sender, objPath, iface, signal, paramList):
    params = {}
    for i in paramList:
        (k, v) = i.split('=', 1)
        params[k] = v
    if (signal == 'add' and params['SUBSYSTEM'] == 'input'
            and 'keyboard' in params['MODEL_NAME'].lower()):
        subprocess.run(os.environ['HOME']+'/bin/fixkeys')


bus = pydbus.SystemBus()
dev = bus.subscribe(iface="org.udev.event", signal_fired=handle_signal)

GLib.MainLoop().run()
```

Tell your window manager to run that script on startup, and it'll handle the rest.

## Notes, Gotchas, and Room for Improvement

* Spaces in the `MODEL_NAME` and `VENDOR_NAME` strings are given by udev with spaces escaped as `\x20`. (Other characters may also be escaped.) This script should escape those, but it currently doesn't.
* Several similar/identical messages are generated for each individual add/remove event. This should be prevented.

## Author

David Perry, aka Boolean263. Inspired by [dimonomid/my-udev-notify](https://github.com/dimonomid/my-udev-notify).
