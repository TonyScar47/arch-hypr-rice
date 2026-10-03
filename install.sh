#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install_progress.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Colors & helper functions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[*]${NC} $*"; }
ok()   { echo -e "${GREEN}[+]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[-]${NC} $*"; }

trap 'err "Installation failed on line $LINENO. See $LOG_FILE for details."' ERR

# 1. Sudo Persistence
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 2. Pacman & Mirror Optimization
info "Configuring Pacman options..."
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
if ! grep -q "ILoveCandy" /etc/pacman.conf; then
    sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
fi
sudo sed -i 's/^#\?ParallelDownloads.*/ParallelDownloads = 10/' /etc/pacman.conf

info "Benchmarking fast HTTPS mirrors..."
sudo pacman -Sy --needed --noconfirm archlinux-keyring reflector
sudo reflector \
    --latest 20 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist || warn "Reflector timed out. Using default mirrors."

info "Upgrading system packages..."
sudo pacman -Syu --noconfirm

# 3. Desktop Rice & Base Developer Packages (No Security Tools)
info "Installing desktop environment, media, fonts, and base dev tools..."
RICE_SUITE=(
    hyprland waybar swaybg wofi foot fastfetch ttf-jetbrains-mono-nerd
    pipewire wireplumber btop network-manager-applet zathura zathura-pdf-mupdf
    libreoffice-fresh pavucontrol networkmanager brightnessctl grim slurp wl-clipboard stow ethtool
)

DEV_CORE=(
    base-devel git neovim zsh tmux zip unzip curl wget
    python python-pip cmake nodejs npm
)

sudo pacman -S --needed --noconfirm "${RICE_SUITE[@]}" "${DEV_CORE[@]}"

# 4. AUR Helper Setup (yay)
if ! command -v yay &>/dev/null; then
    info "Building yay-bin from AUR..."
    BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILD_DIR"
    (cd "$BUILD_DIR" && makepkg -si --noconfirm)
    rm -rf "$BUILD_DIR"
fi

# 5. AUR Desktop Applications & Plugins
info "Installing AUR packages (VS Code, Spotify, Spicetify, Zsh plugins)..."
AUR_APPS=(visual-studio-code-bin zsh-autosuggestions zsh-syntax-highlighting spotify spicetify-cli wlogout)
yay -S --needed --noconfirm "${AUR_APPS[@]}"

# 6. Dotfiles Deployment (GNU Stow)
if [ -d "dotfiles" ]; then
    info "Deploying dotfiles to home directory..."
    (cd dotfiles && stow -t "$HOME" */)
    ok "Dotfiles linked successfully."
else
    warn "'dotfiles' directory not found. Skipping Stow deployment."
fi

# 7. Shell Setup (Oh My Zsh)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# 8. Services
sudo systemctl enable --now NetworkManager

# 9. Spotify & Spicetify Permissions
if command -v spicetify &>/dev/null && [ -d "/opt/spotify" ]; then
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    spicetify backup apply 2>/dev/null || warn "Launch Spotify once before applying themes via Spicetify."
fi

# 10. Default MIME Types (Documents & PDFs)
xdg-mime default org.pwmt.zathura.desktop application/pdf
xdg-mime default libreoffice-writer.desktop application/msword
xdg-mime default libreoffice-writer.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document

# 11. Cache Cleanup
sudo pacman -Sc --noconfirm

ok "Base desktop environment successfully provisioned!"

# 12. Optional Security & CTF Tools Trigger
echo ""
read -r -p "Do you want to install / update the Cyber-Security & CTF Tool Suite? [y/N] " install_cyber_choice
if [[ "$install_cyber_choice" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if [ -f "./install-cyber.sh" ]; then
        chmod +x ./install-cyber.sh
        ./install-cyber.sh
    else
        err "File ./install-cyber.sh not found in the current directory."
    fi
fi

echo ""
ok "All set! You can launch Hyprland via your login manager or TTY."