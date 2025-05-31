#!/bin/bash

ip_address=(
	icon=ip
	icon.font="Hack Nerd Font:Bold:17.0"
	icon.padding_right=0
	label.width=81
	label.align=right
	padding_left=5
	update_freq=30
	label.color=0xffe5a8ff
	script="$PLUGIN_DIR/ip_address.sh"
)

sketchybar --add item ip_address left 
