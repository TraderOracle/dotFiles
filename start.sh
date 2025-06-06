#!/bin/bash

# Start a new tmux session named "market_hours"
tmux new-session -d -s market_hours

# Create additional windows (1-6) for a total of 7
tmux new-window -t my_session:1 -n "SCAN"
delay 0.5
tmux new-window -t my_session:2 -n "PATTERNS"
delay 0.5
tmux new-window -t my_session:3 -n "CURRENT Hotties"
delay 0.5
tmux new-window -t my_session:4 -n ""
delay 0.5
tmux new-window -t my_session:5 -n ""
delay 0.5
tmux new-window -t my_session:6 -n ""

# Send commands to each window
tmux send-keys -t my_session:1 "python ShrikeScan.py" C-m
delay 0.5
tmux send-keys -t my_session:2 "python TAPatterns.py" C-m
delay 0.5
tmux send-keys -t my_session:3 "python CurrentHotties2.py" C-m
delay 0.5
tmux send-keys -t my_session:4 "clear" C-m
delay 0.5
tmux send-keys -t my_session:5 "clear" C-m
delay 0.5
tmux send-keys -t my_session:6 "clear" C-m
delay 0.5

# Attach to the tmux session
tmux attach-session -t market_hours
