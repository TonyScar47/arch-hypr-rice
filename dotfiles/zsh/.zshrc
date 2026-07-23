# --- Zsh Configuration - arch-hypr-rice ---

# 1. ENVIRONMENT VARIABLES

export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR='nvim'

# Python Virtual Environment for CyberChallenge tools
export PATH="$HOME/arch-hypr-rice/venv/bin:$PATH"

# 2. OH-MY-ZSH SETUP

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell" 
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# 3. CUSTOM ALIASES

alias v="nvim"
alias ls="ls --color=auto"
alias fast="fastfetch"

alias update='sudo pacman -Syu && yay -Sua'

# 4. AUTO-START HYPRLAND

# This block ensures Hyprland starts automatically when you log in via TTY1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec Hyprland
fi

# 5. TERMINAL AUTOSTART 
fastfetch
# Remove the hash (#) below to enable the wolf on startup, or add it back to disable it.
# dotfile > fastfetch > .config > fastfetch > wolf.txt