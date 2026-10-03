# Arch Linux · Hyprland · Catppuccin Mocha

Automated Arch Linux setup built around **Hyprland** (Lua configuration format, 0.55+) and themed with **Catppuccin Mocha**. Dotfiles are deployed with **GNU Stow**, so edits stay live through symlinks. An optional module adds a **Cyber-Security & CTF toolchain**, with its Python packages isolated in a dedicated virtual environment.

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?logo=wayland&logoColor=black)
![Catppuccin](https://img.shields.io/badge/Catppuccin-Mocha-cba6f7)
![License](https://img.shields.io/badge/License-MIT-a6e3a1)

---

## Showcase

![Desktop with Waybar, Fastfetch and Neovim](screenshots/desktop.png)

![Wofi launcher — Catppuccin Mocha](screenshots/wofi.png)

![Spotify themed with Spicetify](screenshots/spotify.png)

---

## What's inside

- **WM:** Hyprland, dwindle layout, 3 px gradient borders (mauve→blue), 10 px rounding, slide animations on an overshoot curve
- **Bar:** Waybar — workspaces, clock, CPU/RAM (click → `btop`), network (click → `nm-connection-editor`), battery, audio (click → `pavucontrol`), tray, power menu (`wlogout`)
- **Terminal:** Foot in server mode (`foot --server` + `footclient`), JetBrainsMono Nerd Font, 90% opacity
- **Launcher:** Wofi (`drun` mode, fuzzy matching)
- **Editor:** Neovim on Lazy.nvim + Treesitter, Catppuccin Mocha, `Space` leader
- **Shell:** Zsh + Oh My Zsh, with `zsh-autosuggestions` and `zsh-syntax-highlighting`
- **Extras:** Fastfetch (custom wolf ASCII), Spotify + Spicetify, optional CTF suite

---

## Prerequisites

This is **not** a full-disk installer. It expects an existing base Arch install with:

- A working internet connection
- A non-root user with `sudo` privileges
- `git` available (`sudo pacman -S git`) to clone the repo

The scripts handle everything above that layer: desktop, dotfiles and tooling.

---

## Installation

```bash
git clone https://github.com/TonyScar47/arch-hypr-rice.git
cd arch-hypr-rice
chmod +x install.sh install-cyber.sh
```

### 1. Full desktop rice

```bash
./install.sh
```

At the end you'll be prompted `[y/N]` to also install the Cyber-Security & CTF suite.

### 2. Standalone Cyber & CTF setup

Run this on its own if you only want the CTF tools, Docker/Wireshark permissions and the Python venv on an already-configured system:

```bash
./install-cyber.sh
```

### Starting the session

No display manager is installed. Log in on **TTY1** and `.zshrc` runs `exec start-hyprland`; on any other TTY you get a plain shell.

### What `install.sh` does to your system

Worth knowing before you run it, since it touches system config:

- Enables `Color` + `ILoveCandy` and sets `ParallelDownloads = 10` in `/etc/pacman.conf`
- Refreshes the mirrorlist with `reflector` (20 most recent HTTPS mirrors, sorted by rate), then runs a full system upgrade
- Installs the desktop suite and base dev tools from the official repos
- Builds `yay` if it is not installed, then uses it to install VS Code, Spotify, `spicetify-cli`, `wlogout` and the two Zsh plugins
- Deploys dotfiles with `stow -t "$HOME"`
- Installs Oh My Zsh with `--keep-zshrc`, so the stowed `.zshrc` is not replaced, and sets Zsh as the default shell
- Enables `NetworkManager` and sets default MIME handlers (Zathura for PDF, LibreOffice Writer for `.doc`/`.docx`)

The script can be re-run: packages are installed with `--needed`, and `yay` and Oh My Zsh are skipped if already present. Output is logged to `install_progress.log`.

---

## Cyber-Security & CTF Suite

Security tooling lives in a separate script to keep the base system clean and to avoid PEP 668 conflicts between `pip` and the system package manager.

| Category | Tools |
| --- | --- |
| Network analysis | `nmap`, `wireshark-qt`, `wireshark-cli` (provides `tshark`), `tcpdump`, `openbsd-netcat`, `socat` |
| Reverse engineering & exploitation | `gdb`, `gef`, `ghidra`, `radare2`, `binwalk`, `strace`, `ltrace` |
| Web & password cracking | `burpsuite` (AUR), `sqlmap`, `ngrok` (AUR), `john`, `hashcat` |
| Containers | `docker`, `docker-compose` |
| Utilities | `p7zip`, `unrar` |

The script also enables `docker.service` and adds your user to the `docker` and `wireshark` groups. Output is logged to `install_cyber.log`.

### Python virtual environment (`~/.venvs/ctf`)

An isolated venv is created with: `requests`, `scapy`, `pwntools`, `pycryptodome`, `sympy`, `z3-solver`.

### CTF shell aliases

The aliases are written to `~/.zsh_ctf`, which the repo's `.zshrc` sources only if the file exists. On a system with a different `.zshrc`, the script appends the `source` line once.

| Command | Action |
| --- | --- |
| `ctf-on` | Activate the CTF venv (`source ~/.venvs/ctf/bin/activate`) |
| `ctf-off` | Deactivate the venv |
| `serve` | Local HTTP server on port 8000 |
| `ncl <port>` | Netcat listener (`nc -lvnp <port>`) |
| `b64d` | Base64 decode |
| `rot13` | ROT13 encode/decode |
| `checksec` | Binary security checks (`pwn checksec`) |

> After install, run `source ~/.zshrc` to load the aliases, and log out and back in for the Docker/Wireshark group changes to take effect.

---

## Keyboard Shortcuts

Main modifier is **SUPER** (Windows / Command key).

| Keybinding | Action |
| --- | --- |
| `SUPER + Enter` | Open terminal (`footclient`) |
| `SUPER + D` | Application launcher (Wofi) |
| `SUPER + Q` | Close active window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + Space` | Toggle floating mode |
| `SUPER + Arrow Keys` | Move focus between windows |
| `SUPER + [1-9]` | Switch to workspace 1-9 |
| `SUPER + Shift + [1-9]` | Move active window to workspace 1-9 |
| `SUPER + Left Click (hold)` | Move window freely |
| `SUPER + Right Click (hold)` | Resize window freely |
| `3-finger horizontal swipe` | Switch workspace (touchpad) |
| `Print` | Area screenshot to clipboard (`grim` + `slurp`) |
| `Shift + Print` | Fullscreen screenshot to `~/Pictures/` |
| `Volume / Brightness keys` | Adjust audio (`wpctl`, capped at 150%) and backlight (`brightnessctl`) |

Keyboard layout is set to `it` in `hyprland.lua` — change `kb_layout` there if you use a different one.

---

## Repository Structure

```
arch-hypr-rice/
├── dotfiles/
│   ├── fastfetch/      # Fastfetch layout & wolf ASCII art
│   ├── foot/           # Foot terminal config (Catppuccin Mocha, 0.9 alpha)
│   ├── hyprland/       # Lua-based Hyprland configuration (0.55+) & wallpaper
│   ├── nvim/           # Neovim configuration (Lazy.nvim, Treesitter)
│   ├── waybar/         # Status bar JSON layout & CSS style
│   ├── wofi/           # Wofi launcher (Catppuccin Mocha style & config)
│   └── zsh/            # Zsh configuration & Oh My Zsh settings
├── screenshots/        # Images used in this README
├── install.sh          # Desktop environment installer
├── install-cyber.sh    # Security & CTF suite installer
├── LICENSE
└── README.md
```

Each folder under `dotfiles/` is a Stow package that mirrors the layout of `$HOME`.

### Configuration details

- **Hyprland** (`dotfiles/hyprland/.config/hypr/`): native Lua format. `colors.lua` holds the Catppuccin palette table; `hyprland.lua` handles keybindings, monitors, decoration and autostart. The wallpaper is `~/Pictures/Desktop.jpg`, set with `swaybg`.
- **Waybar** (`dotfiles/waybar/.config/waybar/`): `config` (JSON) + `style.css`. CPU/RAM click opens `btop` in Foot; the power button triggers `wlogout`.
- **Wofi** (`dotfiles/wofi/.config/wofi/`): `style.css` + `config`, Catppuccin Mocha with a mauve accent matching Waybar, fuzzy matching enabled.
- **Foot** (`dotfiles/foot/.config/foot/foot.ini`): JetBrainsMono Nerd Font, Catppuccin Mocha, 90% opacity, Zsh as the shell.
- **Neovim** (`dotfiles/nvim/.config/nvim/init.lua`): Lazy.nvim, Treesitter, `Space` leader, a handful of quality-of-life keymaps.
- **Zsh** (`dotfiles/zsh/.zshrc`): Oh My Zsh with the `git` plugin; `zsh-autosuggestions` and `zsh-syntax-highlighting` are sourced from `/usr/share/zsh/plugins/`.
- **Fastfetch** (`dotfiles/fastfetch/.config/fastfetch/`): hardware/OS metrics next to the `wolf.txt` ASCII art.

---

## Updating & Removing

The dotfiles are symlinks into this repository, so `git pull` applies config changes directly.

To remove the symlinks (installed packages are left in place):

```bash
cd dotfiles
stow -D -t "$HOME" */
```

---

## Spotify & Spicetify

On a fresh install, Spotify has to be opened once before themes can be applied:

1. Open **Spotify** from the launcher, then close it.
2. Run:
   ```bash
   spicetify backup apply
   curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
   ```
3. Restart Spotify to load the Spicetify Marketplace.

---

## Troubleshooting

- **Logs:** check `install_progress.log` (desktop) or `install_cyber.log` (security tools) for exact errors. Both are git-ignored.
- **Stow conflicts:** Stow does not overwrite existing files. If `install.sh` stops at the dotfiles step, move the conflicting file (for example an existing `~/.zshrc`) out of the way and re-run.
- **Pacman cache errors** (mirror timeouts / partial downloads):
  ```bash
  sudo pacman -Scc
  sudo pacman -Syu
  ```
- **Network applet** won't launch from the tray — use the TUI: `nmtui`
- **Docker / Wireshark permissions:** if capture or Docker still needs `sudo`, log out and back in so the group changes apply.

---

## License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.