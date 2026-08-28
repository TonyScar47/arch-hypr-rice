# --- Zsh Configuration - arch-hypr-rice ---

# 1. ENVIRONMENT VARIABLES

export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR='nvim'

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
if [ -z "$DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  exec Hyprland
fi

# 5. TERMINAL AUTOSTART 
fastfetch
# Remove the hash (#) below to enable the wolf on startup, or add it back to disable it.
# dotfile > fastfetch > .config > fastfetch > wolf.txt
# --- CTF Helper Aliases ---
alias ctf-on="source ~/.venvs/ctf/bin/activate"
alias ctf-off="deactivate"
alias serve="python3 -m http.server 8000"
alias ncl="nc -lvnp"
alias b64d="base64 -d"
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias checksec="pwn checksec"
