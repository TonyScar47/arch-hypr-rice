#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install_cyber.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Colors & logging helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[*]${NC} $*"; }
ok()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
err()   { echo -e "${RED}[-]${NC} $*"; }

trap 'err "Installation failed on line $LINENO. See $LOG_FILE for details."' ERR

# Keep sudo alive
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 1. Official Packages
info "Installing core security & analysis tools from official repos..."
SEC_PKGS=(
    nmap wireshark-qt wireshark-cli tcpdump openbsd-netcat socat
    gdb strace ltrace radare2 binwalk ghidra
    john hashcat sqlmap
    python python-pip python-virtualenv
    docker docker-compose p7zip unrar
)
sudo pacman -S --needed --noconfirm "${SEC_PKGS[@]}"

# 2. AUR Tools
AUR_HELPER=""
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
else
    info "AUR helper not found. Installing yay-bin..."
    BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$BUILD_DIR"
    (cd "$BUILD_DIR" && makepkg -si --noconfirm)
    rm -rf "$BUILD_DIR"
    AUR_HELPER="yay"
fi

info "Installing AUR packages (Burp Suite, Ngrok, GEF)..."
$AUR_HELPER -S --needed --noconfirm burpsuite ngrok gef-bin || warn "Some AUR packages failed to install."

# 3. User Groups & Permissions
info "Enabling Docker service and adding $USER to docker & wireshark groups..."
sudo systemctl enable --now docker.service 2>/dev/null || true
sudo usermod -aG docker,wireshark "$USER"

# 4. Isolated Python CTF Virtual Environment
VENV_DIR="$HOME/.venvs/ctf"
info "Setting up Python virtual environment in $VENV_DIR..."
mkdir -p "$HOME/.venvs"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

"$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel
"$VENV_DIR/bin/pip" install --upgrade \
    requests \
    scapy \
    pwntools \
    pycryptodome \
    sympy \
    z3-solver \
    ropper

# 5. Shell Aliases Injection
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && ! grep -q "CTF Helper Aliases" "$ZSHRC"; then
    info "Appending CTF aliases to $ZSHRC..."
    cat << 'EOF' >> "$ZSHRC"

# --- CTF Helper Aliases ---
alias ctf-on="source ~/.venvs/ctf/bin/activate"
alias ctf-off="deactivate"
alias serve="python3 -m http.server 8000"
alias ncl="nc -lvnp"
alias b64d="base64 -d"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias checksec="pwn checksec"
EOF
    ok "Aliases added to $ZSHRC."
fi

echo ""
ok "Cyber & CTF environment ready."
info "Run 'source ~/.zshrc' and use 'ctf-on' to activate the Python environment."
info "Remember to re-login for Docker and Wireshark group permissions to apply."