#!/bin/bash

#Filename: ~/github/dotfiles-latest/sketchybar/felixkratz/items/front_app.sh

front_app=(
	label.font="Hack Nerd Font:Bold:16.0"
	icon.background.drawing=on
	display=active
	script="$PLUGIN_DIR/front_app.sh"
	click_script="open -a 'Mission Control'"

	padding_left=8
	padding_right=15
	icon.color=0xffffea61
  	label.color=0xff9efa57
	shadow.color=0xffaaaaaa
	shadow=on
	corner_radius=19
	blur_radius=7
	label.padding_right=19
	label.padding_left=9
)

sketchybar --add item front_app left \
	--set front_app "${front_app[@]}" \
	--subscribe front_app front_app_switched
