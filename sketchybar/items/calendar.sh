#!/bin/bash

#Filename: ~/github/dotfiles-latest/sketchybar/felixkratz/items/calendar.sh

calendar=(
	icon=cal
	# Using "MesloLGM Nerd Font"
	icon.font="Hack Nerd Font:Bold:17.0"
	# Using default "SF Pro"
	# icon.font="$FONT:Black:12.0"
	icon.padding_right=0
	label.width=81
	label.align=right
	padding_left=5
	update_freq=30
	label.color=0xffe5a8ff
	script="$PLUGIN_DIR/calendar.sh"
	click_script="$PLUGIN_DIR/zen.sh"
)

sketchybar --add item calendar left \
	--set calendar "${calendar[@]}" \
	--subscribe calendar system_woke
