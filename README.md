# Arch Linux | Hyprland | Catppuccin Mocha Rice & CTF Environment

An automated Arch Linux setup based on **Hyprland** (Lua configuration), themed with **Catppuccin Mocha**. It manages dotfiles using **GNU Stow** for real-time symlink updates and provides an optional, modular **Cyber-Security & CTF Tool Suite** with an isolated Python virtual environment.

---

## Installation

Clone the repository to your system:

```bash
git clone https://github.com/tonyscar47/arch-hypr-rice.git
cd arch-hypr-rice
chmod +x install.sh install-cyber.sh
```

### 1. Full Desktop Rice Install

Installs the graphical desktop environment, audio/video drivers, terminal, status bar, and development tools:

```bash
./install.sh
```

> At the end of the script, you will be prompted `[y/N]` to optionally install the Cyber-Security & CTF Suite.
> 
> 

### 2. Standalone Cyber & CTF Setup

If you only want to install or update the CTF tools, Docker/Wireshark permissions, and the Python virtual environment on an existing system:

```bash
./install-cyber.sh
```

---

## Cyber-Security & CTF Suite

Security tools are maintained in `install-cyber.sh` to keep the base system clean and prevent Python PEP 668 package manager conflicts:

* **Network Analysis:** `nmap`, `wireshark-qt`, `tshark`, `tcpdump`, `openbsd-netcat`, `socat`

* **Reverse Engineering & Exploitation:** `gdb`, `gef-bin` (AUR), `ghidra`, `radare2`, `binwalk`, `strace`, `ltrace`

* **Web & Password Cracking:** `burpsuite` (AUR), `sqlmap`, `ngrok` (AUR), `john`, `hashcat`

* **Containers:** `docker`, `docker-compose` (auto-configures `docker` and `wireshark` user groups)

### Python Virtual Environment (`~/.venvs/ctf`)

The installer creates an isolated environment containing: `requests`, `scapy`, `pwntools`, `pycryptodome`, `sympy`, `z3-solver`, and `ropper`.

### CTF Shell Aliases

| Command | Action |
| --- | --- |
| `ctf-on` | Activates the isolated CTF Python environment (`source ~/.venvs/ctf/bin/activate`)

 |
| `ctf-off` | Deactivates the virtual environment

 |
| `serve` | Starts a local HTTP server on port 8000 (`python3 -m http.server 8000`)

 |
| `ncl <port>` | Starts a Netcat listener (`nc -lvnp <port>`)

 |
| `b64d` | Quick Base64 decoder (`base64 -d`)

 |
| `rot13` | Quick ROT13 decoder

 |
| `checksec` | Runs binary security checks (`pwn checksec`)

 |

---

## Keyboard Shortcuts

The main modifier key is **SUPER** (Windows / Command key):

| Keybinding | Action |
| --- | --- |
| `SUPER + Enter` | Open Terminal (`Foot`)

 |
| `SUPER + D` | Application Launcher (`Wofi`)

 |
| `SUPER + Q` | Close active window

 |
| `SUPER + F` | Toggle Fullscreen

 |
| `SUPER + Space` | Toggle Floating mode

 |
| `SUPER + Arrow Keys` | Move window focus

 |
| `SUPER + [1-9]` | Switch to workspace `1-9`<br> |
| `SUPER + Shift + [1-9]` | Move active window to workspace `1-9`<br> |
| `SUPER + Left Click (Hold)` | Move window freely

 |
| `SUPER + Right Click (Hold)` | Resize window freely

 |
| `Print Screen` | Interactive area screenshot to clipboard (`grim` + `slurp`)

 |
| `Shift + Print Screen` | Fullscreen screenshot saved to `~/Pictures/`<br> |

---

## Repository Structure

```
arch-hypr-rice/
├── dotfiles/
│   ├── fastfetch/      # Fastfetch layout & wolf ASCII art
│   ├── foot/           # Foot terminal config (Catppuccin Mocha, 0.9 alpha)
│   ├── hyprland/       # Lua-based Hyprland configuration (0.55+)
│   ├── nvim/           # Neovim configuration (Lazy.nvim, Treesitter)
│   ├── waybar/         # Status bar JSON layout & CSS style
│   └── zsh/            # Zsh configuration & Oh My Zsh settings
├── install.sh          # Desktop environment installer
├── install-cyber.sh    # Security & CTF suite installer
└── README.md
```

### Configuration Details

* **Hyprland (`dotfiles/hyprland/.config/hypr/`):** Uses the native Lua configuration format. `colors.lua` contains the Catppuccin palette table, while `hyprland.lua` handles keybindings, monitors, window decoration, and autostart commands.


* **Waybar (`dotfiles/waybar/.config/waybar/`):** Defined via `config` (JSON) and `style.css`. Clicking CPU/RAM opens `btop` in Foot; power button triggers `wlogout`.


* **Foot (`dotfiles/foot/.config/foot/foot.ini`):** Configured with JetBrainsMono Nerd Font, Catppuccin Mocha colors, and 90% opacity.


* **Neovim (`dotfiles/nvim/.config/nvim/init.lua`):** Uses `Lazy.nvim` as plugin manager, `nvim-treesitter` for syntax highlighting, and `Space` as the leader key.


* **Fastfetch (`dotfiles/fastfetch/.config/fastfetch/`):** Displays hardware and OS metrics alongside the ASCII art from `wolf.txt`.

---

## Spotify & Spicetify Setup

On new installations, Spotify must be opened once before themes can be applied:

1. Open **Spotify** from your app launcher, then close it.


2. Run in terminal:
```bash
spicetify backup apply
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
```

3. Restart Spotify to load Spicetify Marketplace.

---

## Troubleshooting

* **Logs:** Check `install_progress.log` (for base desktop) or `install_cyber.log` (for security tools) for exact error outputs.

* **Pacman Cache Errors:** If mirrors time out or download partial packages:
```bash
sudo pacman -Scc
sudo pacman -Syu
```

* **Network Applet:** If the tray network applet fails to launch, open the terminal UI:
```bash
nmtui
```

* **Docker / Wireshark Permissions:** If packet capture or Docker commands require sudo, log out and log back in to apply group permissions.

---

## License

Distributed under the **MIT License**.