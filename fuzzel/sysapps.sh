#!/bin/bash

SELECTION="$(printf "\
LACT\0icon\x1fio.github.lact-linux\n\
Network\0icon\x1fcs-network\n\
Bluetooth\0icon\x1fblueman\n\
Sound\0icon\x1fcs-sound\n\
Passwords/Keys\0icon\x1forg.gnome.seahorse.Application\n\
Disks\0icon\x1forg.gnome.DiskUtility\n\
Disk Usage\0icon\x1forg.gnome.baobab\n\
Printers\0icon\x1fprinter\n\
System Monitor\0icon\x1forg.gnome.SystemMonitor\n\
USB Image (Writer)\0icon\x1fmintstick\n\
USB Image (Format)\0icon\x1fmintstick\n\
Update Manager\0icon\x1fmintupdate\n\
Driver Manager\0icon\x1fmintdrivers\n\
System Settings\0icon\x1fpreferences-desktop\n\
" | fuzzel --dmenu -l 13 -p "Sys App: \
")"

case $SELECTION in
    *"LACT")
        lact gui;;
    *"Network")
        cinnamon-settings network;;
    *"Bluetooth")
        exec blueman-manager;;
    *"Sound")
        exec cinnamon-settings sound;;
    *"Passwords/Keys")
        exec seahorse;;
    *"Disks")
        exec gnome-disks;;
    *"Disk Usage")
        exec baobab;;
    *"Printers")
        exec system-config-printer;;
    *"System Monitor")
        exec gnome-system-monitor;;
    *"USB Image (Writer)")
        exec mintstick -m iso;;
    *"USB Image (Format)")
        exec mintstick -m format;;
    *"Update Manager")
        exec mintupdate;;
    *"Driver Manager")
        exec driver-manager;;
    *"System Settings")
        exec env WEBKIT_DISABLE_COMPOSITING_MODE=1 cinnamon-settings
esac
