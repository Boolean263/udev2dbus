#!/bin/sh

# For udev add/remove rules, send dbus messages
# Inspired by https://github.com/dimonomid/my-udev-notify/

# Most of the items we could be interested in come from the environment.
# Useful keys include:
# ACTION=add
# DEVLINKS=/dev/input/by-path/pci-0000:00:1d.0-usb-0:1.4.4.2:1.1-event /dev/input/by-id/usb-Kingston_HyperX_Alloy_FPS_Pro_Mechanical_Gaming_Keyboard-event-if01
# DEVNAME=/dev/input/event25
# DEVPATH=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4.4/2-1.4.4.2/2-1.4.4.2:1.1/0003:0951:16D2.0023/input/input62/event25
# ID_BUS=usb
# ID_INPUT=1
# ID_INPUT_KEY=1
# ID_MODEL=HyperX_Alloy_FPS_Pro_Mechanical_Gaming_Keyboard
# ID_MODEL_ENC=HyperX\x20Alloy\x20FPS\x20Pro\x20Mechanical\x20Gaming\x20Keyboard
# ID_MODEL_ID=16d2
# ID_PATH=pci-0000:00:1d.0-usb-0:1.4.4.2:1.1
# ID_PATH_TAG=pci-0000_00_1d_0-usb-0_1_4_4_2_1_1
# ID_REVISION=2112
# ID_SERIAL=Kingston_HyperX_Alloy_FPS_Pro_Mechanical_Gaming_Keyboard
# ID_TYPE=hid
# ID_USB_DRIVER=usbhid
# ID_USB_INTERFACES=:030101:030102:030000:
# ID_USB_INTERFACE_NUM=01
# ID_VENDOR=Kingston
# ID_VENDOR_ENC=Kingston
# ID_VENDOR_ID=0951
# LIBINPUT_DEVICE_GROUP=3/951/16d2:usb-0000:00:1d.0-1.4.4
# MAJOR=13
# MINOR=89
# SEQNUM=10506
# SUBSYSTEM=input
# TAGS=:power-switch:

if [ -z "$ID_BUS" ] || [ -z "$SUBSYSTEM" ] ; then
    exit 0
fi

dbus-send --system \
    '/org/udev/event' \
    "org.udev.event.$ACTION" \
    "string:BUS=$ID_BUS" \
    "string:TYPE=$ID_TYPE" \
    "string:SUBSYSTEM=$SUBSYSTEM" \
    "string:VENDOR=$ID_VENDOR_ID" \
    "string:MODEL=$ID_MODEL_ID" \
    "string:VENDOR_NAME=$ID_VENDOR_ENC" \
    "string:MODEL_NAME=$ID_MODEL_ENC"
