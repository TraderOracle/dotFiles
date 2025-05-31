#!/bin/bash

cpu_top=(
  label.font="$FONT:Semibold:19"
  label=CPU
  icon.drawing=off
  width=0
  padding_right=5
  y_offset=6
)

cpu_percent=(
  label.font="$FONT:Heavy:19"
  label=CPU
  y_offset=-4
  padding_right=5
  width=55
  icon.drawing=off
  update_freq=4
  mach_helper="$HELPER"
)

cpu_sys=(
  width=0
  graph.color=$RED
  graph.fill_color=$RED
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

cpu_user=(
  graph.color=$BLUE
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

sketchybar --add item cpu.percent right          \
           --set cpu.percent "${cpu_percent[@]}" \
                                                 \
           --add graph cpu.sys right 75          \
           --set cpu.sys "${cpu_sys[@]}"         \

