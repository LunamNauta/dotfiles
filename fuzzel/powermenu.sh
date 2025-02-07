#!/bin/bash

SELECTION="$(printf "\
Lock\n\
Suspend\n\
Log out\n\
Reboot\n\
Reboot to UEFI\n\
Hard reboot\n\
Shutdown"\
| rofi -width 10 -dmenu -i -p "Power: \
")"

case $SELECTION in
	*"Lock")
		swaylock;;
	*"Suspend")
		systemctl suspend;;
	*"Log out")
		swaymsg exit;;
	*"Reboot")
		systemctl reboot;;
	*"Reboot to UEFI")
		systemctl reboot --firmware-setup;;
	*"Hard reboot")
		pkexec "echo b > /proc/sysrq-trigger";;
	*"Shutdown")
		systemctl poweroff;;
esac
