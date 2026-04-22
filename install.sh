#!/bin/bash

# ==============================================================================
# ARCH-HYPR-RICE & CYBER-SECURITY PROVISIONING SCRIPT (V1.0)
# ==============================================================================
# This script automates the installation of Hyprland, system dotfiles,
# development tools, and security suites. It is designed to be idempotent.

# --- Terminal Colors ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# --- Logging & Error Handling ---
LOG_FILE="install_progress.log"
exec > >(tee -a "$LOG_FILE") 2>&1
set -euo pipefail
trap 'echo -e "\n${RED}[!] CRITICAL ERROR: Check $LOG_FILE for details.${NC}\n"' ERR

echo -e "${BLUE}--- INITIALIZING FULL SYSTEM SETUP ---${NC}"

# --- 1. SUDO PERSISTENCE ---
# Keeps sudo active throughout the installation process
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 2. REPOSITORY & MIRROR OPTIMIZATION ---
# Optimize parallel downloads and sync mirrors globally (Wiki-approved method)
echo -e "${GREEN}[*] Optimizing Pacman configuration...${NC}"
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads = 10/' /etc/pacman.conf

echo -e "${GREEN}[*] Benchmarking mirrors for maximum speed...${NC}"
sudo pacman -Sy --needed --noconfirm archlinux-keyring reflector

# Generic reflector command: picks latest 20 HTTPS mirrors, sorted by transfer rate
sudo reflector \
    --latest 20 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist || echo "Reflector failed, using default mirrors."

# Perform full system synchronization
sudo pacman -Syu --noconfirm

# --- 3. CORE PACKAGE INSTALLATION ---
# Installing Desktop Environment, Core Tools, and Security Suites
echo -e "${GREEN}[*] Installing official repository packages...${NC}"

# Categorized Package Lists
RICE_SUITE=(hyprland waybar swaybg wofi foot stow fastfetch ttf-jetbrains-mono-nerd pipewire wireplumber)
DEV_CORE=(base-devel git neovim zsh python python-pip cmake curl tmux zip unzip firefox)
SEC_SUITE=(nmap wireshark-qt tcpdump sqlmap john hashcat gdb strace ltrace radare2 binwalk)

sudo pacman -S --needed --noconfirm "${RICE_SUITE[@]}" "${DEV_CORE[@]}" "${SEC_SUITE[@]}"

# --- 4. AUR HELPER SETUP (YAY) ---
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[*] Building yay-bin from AUR...${NC}"
    BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILD_DIR"
    cd "$BUILD_DIR" && makepkg -si --noconfirm && cd -
    rm -rf "$BUILD_DIR"
fi

# --- 5. AUR & THIRD-PARTY APPLICATIONS ---
echo -e "${GREEN}[*] Installing AUR packages (VS Code, Burp Suite, etc.)...${NC}"
AUR_APPS=(visual-studio-code-bin burpsuite ngrok zsh-autosuggestions zsh-syntax-highlighting)
yay -S --needed --noconfirm "${AUR_APPS[@]}"

# --- 6. DOTFILES DEPLOYMENT (GNU STOW) ---
# Links configurations from the repo to the user's home directory
echo -e "${GREEN}[*] Deploying dotfiles via GNU Stow...${NC}"
if [ -d "dotfiles" ]; then
    cd dotfiles
    # Use stow to symlink all modules to the Home directory
    stow -t "$HOME" */
    cd ..
else
    echo -e "${RED}[!] 'dotfiles' directory not found. Skipping deployment.${NC}"
fi

# --- 7. SHELL & FRAMEWORK CONFIGURATION ---
# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}[*] Installing Oh My Zsh framework...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Change default shell to Zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# --- 8. SYSTEM SERVICES & PERMISSIONS ---
echo -e "${GREEN}[*] Configuring system services and user groups...${NC}"
sudo systemctl enable --now docker.service
sudo usermod -aG docker,wireshark "$USER"

# --- 9. PYTHON VIRTUAL ENVIRONMENT ---
# Dedicated environment for CyberChallenge tools
if [ ! -d "venv" ]; then
    echo -e "${GREEN}[*] Creating Python Virtual Environment...${NC}"
    python -m venv venv
    ./venv/bin/pip install --upgrade pip
    ./venv/bin/pip install requests scapy pwntools pycryptodome
fi

# --- 10. CLEANUP & FINALIZATION ---
echo -e "${GREEN}[*] Cleaning up package cache...${NC}"
sudo pacman -Sc --noconfirm

echo -e "\n${BLUE}============================================================${NC}"
echo -e "${GREEN}SUCCESS: System is fully provisioned and themed.${NC}"
echo -e "${BLUE}POST-INSTALLATION NOTES:${NC}"
echo -e "1. Run ${RED}Hyprland${NC} to start your desktop session."
echo -e "2. Use the ${RED}update${NC} alias to keep your system and AUR synced."
echo -e "3. NGROK: Remember to add your authtoken: ${RED}ngrok config add-authtoken <TOKEN>${NC}"
echo -e "${BLUE}============================================================${NC}\n"