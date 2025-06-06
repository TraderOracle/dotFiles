#!/bin/bash

brew upgrade

delay 1.5

rm ~/Documents/Github/TheShrike/*.png
delay 1.5
rm ~/Desktop/*.jpg
delay 1.5
rm ~/Documents/Github/TheShrike/*.log

delay 1.5

# Start a new tmux session named "pre_market"
tmux new-session -d -s pre_market

tmux new-window -t my_session:1 -n "WORKING"
delay 0.5
tmux new-window -t my_session:2 -n "PRE Hotties"
delay 0.5
tmux new-window -t my_session:3 -n "NEWS"
delay 0.5
tmux new-window -t my_session:4 -n "Telegram PRE Hotties"
delay 0.5
tmux new-window -t my_session:5 -n "HULK"

delay 0.5

# Send commands to each window
tmux send-keys -t my_session:1 "clear" C-m
delay 0.5
tmux send-keys -t my_session:2 "python PreMarketHotties.py" C-m
delay 0.5
tmux send-keys -t my_session:3 "python TripleNews.py" C-m
delay 0.5
tmux send-keys -t my_session:4 "python TelegramPreMarketHotties.py" C-m
delay 0.5
tmux send-keys -t my_session:5 "python HulkScanJune.py" C-m
delay 0.5

# Attach to the tmux session
tmux attach-session -t pre_market

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'
BLINK='\033[5m'

# Detect OS
OS_TYPE=$(uname -s)

# Function to show loading animation
show_loading() {
    local message=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    printf "${CYAN}${message}"
    for i in {1..10}; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b${NC}\n"
}

# Function to get memory info based on OS
get_memory_info() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS
        local total_mem=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))
        local page_size=$(vm_stat | grep "page size" | grep -o '[0-9]*')
        local free_pages=$(vm_stat | grep "Pages free" | grep -o '[0-9]*')
        local inactive_pages=$(vm_stat | grep "Pages inactive" | grep -o '[0-9]*')
        local free_mem=$(( ($free_pages + $inactive_pages) * $page_size / 1024 / 1024 / 1024 ))
        local used_mem=$(( $total_mem - $free_mem ))
        local mem_percent=$(( $used_mem * 100 / $total_mem ))
        echo "${used_mem}G/${total_mem}G (${mem_percent}% used)"
    else
        # Linux
        if command -v free &> /dev/null; then
            free -h | awk 'NR==2{printf "%s/%s (%.1f%% used)", $3, $2, $3/$2*100}'
        else
            echo "N/A"
        fi
    fi
}

# Function to get CPU info
get_cpu_info() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS
        local cpu_model=$(sysctl -n machdep.cpu.brand_string)
        local cpu_cores=$(sysctl -n hw.ncpu)
        echo "$cpu_model ($cpu_cores cores)"
    else
        # Linux
        local cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
        local cpu_cores=$(nproc)
        echo "$cpu_model ($cpu_cores cores)"
    fi
}

# Function to get disk usage
get_disk_usage() {
    df -h / | awk 'NR==2{printf "%s/%s (%s used)", $3, $2, $5}'
}

# Function to get top processes
get_top_processes() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        ps aux | sort -nrk 3,3 | head -6 | tail -5 | awk '{printf "  %-20s %5s%% %5s%% %s\n", substr($11,1,20), $3, $4, $2}'
    else
        ps aux | sort -nrk 3,3 | head -6 | tail -5 | awk '{printf "  %-20s %5s%% %5s%% %s\n", substr($11,1,20), $3, $4, $2}'
    fi
}

# Clear screen
clear

# Compact Good Morning Greeting
echo -e "${YELLOW}☀️  ${BOLD}GOOD MORNING!${NC} ${YELLOW}☀️${NC}  $(date '+%A, %B %d, %Y - %I:%M %p')"
echo -e "${DIM}────────────────────────────────────────────────────────────────────────${NC}"
echo ""

# System Overview
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                   ${BOLD}${WHITE}💻 SYSTEM OVERVIEW${NC} ${BLUE}                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Basic System Info
echo -e "${CYAN}📊 Basic Information:${NC}"
echo -e "  🖥️  ${BOLD}Hostname:${NC} $(hostname)"
echo -e "  🐧 ${BOLD}OS:${NC} $(uname -s) $(uname -r)"
echo -e "  🏗️  ${BOLD}Architecture:${NC} $(uname -m)"
echo -e "  👤 ${BOLD}User:${NC} $(whoami)"
echo -e "  🔧 ${BOLD}Shell:${NC} $SHELL"
echo ""

# Hardware Information
echo -e "${CYAN}🔧 Hardware:${NC}"
echo -e "  🧠 ${BOLD}CPU:${NC} $(get_cpu_info)"
echo -e "  💾 ${BOLD}Memory:${NC} $(get_memory_info)"
echo -e "  💽 ${BOLD}Disk (/):${NC} $(get_disk_usage)"
echo ""

# Performance Metrics
echo -e "${CYAN}⚡ Performance:${NC}"
echo -e "  ⏰ ${BOLD}Uptime:${NC}$(uptime | sed 's/.*up//' | sed 's/,.*users.*//' | sed 's/^ *//')"
echo -e "  📈 ${BOLD}Load Average:${NC}$(uptime | grep -o 'load average:.*' | cut -d: -f2)"

# CPU Usage (if available)
if command -v mpstat &> /dev/null; then
    CPU_USAGE=$(mpstat 1 1 | tail -1 | awk '{print 100-$12}')
    echo -e "  🔥 ${BOLD}CPU Usage:${NC} ${CPU_USAGE}%"
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    CPU_USAGE=$(ps aux | awk '{sum+=$3} END {print sum}')
    echo -e "  🔥 ${BOLD}CPU Usage:${NC} ${CPU_USAGE}%"
fi
echo ""

# Network Information
echo -e "${CYAN}🌐 Network:${NC}"
if [[ "$OS_TYPE" == "Darwin" ]]; then
    # macOS
    MAIN_IF=$(route -n get default | grep interface | awk '{print $2}')
    IP_ADDR=$(ipconfig getifaddr $MAIN_IF 2>/dev/null || echo "N/A")
    echo -e "  🔌 ${BOLD}Interface:${NC} $MAIN_IF"
    echo -e "  🏠 ${BOLD}Local IP:${NC} $IP_ADDR"
else
    # Linux
    MAIN_IF=$(ip route | grep default | awk '{print $5}' | head -1)
    IP_ADDR=$(ip addr show $MAIN_IF 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1 || echo "N/A")
    echo -e "  🔌 ${BOLD}Interface:${NC} $MAIN_IF"
    echo -e "  🏠 ${BOLD}Local IP:${NC} $IP_ADDR"
fi
echo -e "  🌍 ${BOLD}Public IP:${NC} $(curl -s ifconfig.me 2>/dev/null || echo "N/A")"
echo ""

# Process Information
echo -e "${CYAN}🔄 Top Processes (by CPU):${NC}"
echo -e "  ${DIM}Process              CPU%  MEM%  PID${NC}"
get_top_processes
echo ""

# Disk Information (all mounted disks)
echo -e "${CYAN}💿 Disk Usage:${NC}"
df -h | grep -E '^/dev/' | head -5 | while read line; do
    USAGE=$(echo $line | awk '{print $5}' | sed 's/%//')
    if [ $USAGE -gt 80 ]; then
        COLOR=$RED
    elif [ $USAGE -gt 60 ]; then
        COLOR=$YELLOW
    else
        COLOR=$GREEN
    fi
    echo -e "  $(echo $line | awk '{printf "%-20s %8s %8s %8s %s%5s%s\n", $1, $2, $3, $4, "'"$COLOR"'", $5, "'"$NC"'"}')"
done
echo ""

RANDOM_TIP=${TIPS[$RANDOM % ${#TIPS[@]}]}
echo -e "${WHITE}💡 ${RANDOM_TIP}${NC}"
echo -e "${DIM}────────────────────────────────────────────────────────────────────────${NC}"
echo ""