# --- Zsh Configuration - arch-hypr-rice ---

# 1. ENVIRONMENT VARIABLES

# Define your preferred text editor and system paths
export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR='nvim'

# Python Virtual Environment for CyberChallenge tools
export PATH="$HOME/arch-hypr-rice/venv/bin:$PATH"

# 2. OH-MY-ZSH SETUP

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme and Plugins (Requires zsh-autosuggestions and zsh-syntax-highlighting)
ZSH_THEME="robbyrussell" 
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 3. CUSTOM ALIASES

# Shortcuts for common tasks
alias v="nvim"
alias ls="ls --color=auto"
alias fast="fastfetch"

# The ultimate alias for full system synchronization and updates (Official Repos + AUR)
alias update='sudo pacman -Syu && yay -Sua'

# 4. AUTO-START HYPRLAND

# This block ensures Hyprland starts automatically when you log in via TTY1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec Hyprland
fi