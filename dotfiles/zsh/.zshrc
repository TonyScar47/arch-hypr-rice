# --- Zsh Configuration - arch-hypr-rice ---

# 1. ENVIRONMENT VARIABLES

export PATH=$HOME/bin:/usr/local/bin:$PATH
export EDITOR='nvim'

# 2. OH-MY-ZSH SETUP

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# 3. CUSTOM ALIASES

alias v="nvim"
alias ls="ls --color=auto"
alias fast="fastfetch"

alias update='sudo pacman -Syu && yay -Sua'

[ -f "$HOME/.zsh_ctf" ] && source "$HOME/.zsh_ctf"

# 4. AUTO-START HYPRLAND

# This block ensures Hyprland starts automatically when you log in via TTY1
if [ -z "$DISPLAY" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  exec start-hyprland
fi

# 5. TERMINAL AUTOSTART
fastfetch