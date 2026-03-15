#!/bin/bash

# --- COLOR DEFINITIONS (RAINBOW) ---
R='\e[38;5;196m'; O='\e[38;5;208m'; Y='\e[38;5;226m'; G='\e[38;5;46m'
B='\e[38;5;33m'; P='\e[38;5;129m'; C='\e[38;5;51m'; RESET='\e[0m'

show_header() {
    clear
    echo -e "${R}################################################################################${RESET}"
    echo -e "${O}  ____  __    __ __  __    ____    _      _   _  _____  _      ${RESET}"
    echo -e "${Y} / ___| \ \  / /|  \/  |  |  _ \  / \    | \ | || ____|| |     ${RESET}"
    echo -e "${G} \___ \  \ \/ / | |\/| |  | |_) / _ \   |  \| ||  _|  | |     ${RESET}"
    echo -e "${B}  ___) |  \  /  | |  | |  |  __/ ___ \  | |\  || |___ | |___  ${RESET}"
    echo -e "${P} |____/    \/   |_|  |_|  |_| /_/   \_\ |_| \_||_____||_____| ${RESET}"
    echo -e "${R}################################################################################${RESET}"
    echo -e "${P}      >> VERSION 04 - PREMIUM EDITION | MADE BY ANKIT-DEV <<${RESET}"
    echo -e "${R}################################################################################${RESET}"
}

# --- 1. LICENSE GATE (Security First) ---
check_license() {
    show_header
    echo -e "${Y}   [!] AUTHENTICATION REQUIRED [!]"
    read -p "   Enter License Key: " KEY
    if [[ "$KEY" == "AnkitDev99$@" ]]; then
        echo -e "${G}   [✔] License Verified! Access Granted.${RESET}"
        sleep 1
        menu
    else
        echo -e "${R}   [✖] Invalid Key! Access Denied.${RESET}"
        sleep 1
        check_license
    fi
}

# --- 2. SETUP COMMANDS ---
run_setup() {
    echo -e "${C}--> [1/5] Updating System & Installing Core Tools...${RESET}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y unzip snapd bridge-utils uidmap lxc-utils python3-pip python3-venv

    echo -e "${C}--> [2/5] Initializing LXD Container Engine...${RESET}"
    sudo snap install lxd
    sudo usermod -aG lxd $USER
    sudo lxd init --auto

    echo -e "${C}--> [3/5] Preparing Python Virtual Environment...${RESET}"
    [ ! -d "venv" ] && python3 -m venv venv
    source venv/bin/activate
    pip install --upgrade pip
    [ -f "requirements.txt" ] && pip install -r requirements.txt

    echo -e "${C}--> [4/5] Deploying SVM Panel on Port 3000...${RESET}"
    sudo bash -c "cat <<EOF > /etc/systemd/system/svm-panel.service
[Unit]
Description=SVM Panel v4 - Ankit-Dev
After=network.target lxd.service

[Service]
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/venv/bin/python3 Svm.py --port 3000
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF"

    echo -e "${C}--> [5/5] Finalizing Systemd...${RESET}"
    sudo systemctl daemon-reload
    sudo systemctl enable svm-panel --now
    
    echo -e "\n${G}########################################################"
    echo -e "${G} ✅ INSTALLATION SUCCESSFUL!"
    echo -e "${G} 🌐 PANEL ACTIVE ON: http://YOUR_IP:3000"
    echo -e "${G} 🚀 STATUS: RUNNING"
    echo -e "${G}########################################################${RESET}"
    exit 0
}

# --- 3. MENU ---
menu() {
    show_header
    echo -e "${B} 1) ${Y}License Key Status: ${G}VERIFIED${RESET}"
    echo -e "${B} 2) ${Y}Set Panel Owner/Friend Name${RESET}"
    echo -e "${B} 3) ${Y}Buy License Key (UPI: 9892642904@ybl)${RESET}"
    echo -e "${B} 4) ${C}RUN FULL INSTALLATION (Deploy)${RESET}"
    echo -e "${B} 5) ${R}Exit${RESET}\n"
    read -p "Select Option [1-5]: " choice
    case $choice in
        1) echo "Key verified."; sleep 1; menu ;;
        2) read -p "Enter Name: " n; echo "Owner set: $n"; sleep 1; menu ;;
        3) echo "UPI: 9892642904@ybl"; read -n 1; menu ;;
        4) run_setup ;;
        5) exit 0 ;;
        *) menu ;;
    esac
}

# Start
check_license
