#!/bin/bash

# ==============================================================================
# Title: Svm Panel v4 - Professional Edition
# Developer: ANKIT DEV
# ==============================================================================

clear

# Large "Long Letter" ASCII Header
echo "################################################################################"
echo "  ____ __     __ __  __   ____   _      _   _  _____  _      "
echo " / ___|\\ \\   / /|  \\/  | |  _ \\ / \\    | \\ | || ____|| |     "
echo " \\___ \\ \\ \\ / / | |\\/| | | |_) / _ \\   |  \\| ||  _|  | |     "
echo "  ___) | \\ V /  | |  | | |  __/ ___ \\  | |\\  || |___ | |___  "
echo " |____/   \\_/   |_|  |_| |_| /_/   \\_\\ |_| \\_||_____||_____| "
echo "                                                                "
echo "                      VERSION 4.0 - PREMIUM                     "
echo "                   --- MADE BY ANKIT DEV ---                    "
echo "################################################################################"
echo ""

# 1. Update & Core Tools
echo "--> [1/7] Updating system and installing ZIP tools..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y unzip snapd bridge-utils uidmap lxc-utils python3-pip python3-venv

# 2. Extracting Files
echo "--> [2/7] Unzipping static assets..."
if [ -f "static.zip" ]; then
    unzip -o static.zip
    echo "✔ Files extracted."
else
    echo "✖ Error: static.zip not found! Please upload it first."
fi

# 3. LXD Installation
echo "--> [3/7] Setting up LXD Virtualization..."
sudo snap install lxd
sudo usermod -aG lxd $USER

# 4. Auto-Initialize LXD
echo "--> [4/7] Configuring LXD Network Bridge..."
sudo lxd init --auto

# 5. Virtual Environment Setup
echo "--> [5/7] Preparing Python 3 Virtual Environment..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# 6. Install Dependencies
echo "--> [6/7] Installing requirements.txt..."
source venv/bin/activate
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "✖ Warning: requirements.txt missing!"
fi

# 7. Final Launch
echo ""
echo "================================================================================"
echo " ✅ INSTALLATION FINISHED BY ANKIT DEV"
echo " 🌐 PORT: 5000"
echo " 🚀 STARTING SVM PANEL NOW..."
echo "================================================================================"
echo ""

# Run the panel automatically
# We use 'python3' from the venv directly to ensure it runs
./venv/bin/python3 Svm.py
