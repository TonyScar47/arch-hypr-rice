# ❄️ Arch Linux | Hyprland | Catppuccin Mocha | Automated Rice

This project automates the installation and configuration of an Arch Linux desktop environment based on Hyprland, using the Catppuccin Mocha theme. It is designed to be **instantly customizable**: you can tweak the files before the installation or modify them later to see changes applied in real-time via GNU Stow symlinks.

---

## 🚀 Installation

To ensure the installation works correctly and configurations are applied, you must clone the entire repository so the script can locate the `dotfiles` folder.

### Quick Install (Standard)
If you want to install the system with my default configurations, open your terminal and run:

```bash
git clone [https://github.com/YOUR-USERNAME/arch-hypr-rice.git](https://github.com/YOUR-USERNAME/arch-hypr-rice.git)
cd arch-hypr-rice
chmod +x install.sh
./install.sh
```

### Custom Install

If you want to modify the setup before installing:

    Clone the repository using the git clone command above.
    Navigate into the folders inside dotfiles/ and modify the files according to your preferences.
    If you want to add or remove programs, open install.sh and edit the RICE_SUITE, DEV_CORE, SEC_SUITE, or AUR_APPS arrays.
    Run ./install.sh.

---

## ⌨️ Keyboard Shortcuts (Keybindings)

All shortcuts use the SUPER key (the Windows or Command key) as the main modifier.

    SUPER + Enter (RETURN): Opens the terminal (Foot).

    SUPER + D: Opens the application launcher (Wofi).

    SUPER + Q: Closes the active window.

    SUPER + F: Toggles Fullscreen mode.

    SUPER + Space: Toggles Floating mode.

    SUPER + Arrows (Up/Down/Left/Right): Moves focus between open windows.

    SUPER + Numbers (1-9): Switches workspaces.

    SUPER + Shift + Numbers (1-9): Silently moves the current window to the selected workspace.

    SUPER + Left Click (Hold): Moves the window freely with the mouse.

    SUPER + Right Click (Hold): Resizes the window with the mouse.

    Print Screen (PRINT): Select an area with the mouse and copy it to the clipboard.

    Shift + Print Screen (PRINT): Takes a full-screen screenshot and saves it automatically to the Pictures folder.

---

## 🛠️ Structure & Customization

All configurations are managed using GNU Stow. This means the files in the dotfiles/ folder are directly symlinked to your system; any saved change will become instantly active.

### 1. Installation Script (install.sh) 

This script is the core of the automation and executes the following steps sequentially:
* **Sudo Persistence**: Keeps administrator privileges active in the background throughout the installation process.
* **Pacman & Mirror Optimization**: Sets ParallelDownloads = 10 and uses reflector to automatically find, test, and save the 20 fastest HTTPS mirrors.
+ **Core Installation**: Installs official packages divided into three modular categories:
  
  1. RICE_SUITE: Graphical environment and visual tools (Hyprland, Waybar, Wofi, Foot, Fastfetch, fonts, and audio drivers).

  2. DEV_CORE: Base development tools (Git, Neovim, Zsh, Python, CMake, etc.).

  3. SEC_SUITE: Cybersecurity tools (Nmap, Wireshark, SQLmap, Hashcat, Radare2, etc.).

* **AUR & Third-Party Setup**: Builds yay-bin (if missing) and uses it to install VS Code, Burp Suite, Ngrok, Zsh plugins, and Spotify.

* **Dotfiles Deployment**: Runs GNU Stow to create symbolic links from the dotfiles directory to the user's Home folder.

* **System Environment**: Installs Oh My Zsh, sets zsh as the default shell, enables system services (Docker, NetworkManager), and adds the user to essential groups (docker, wireshark).

* **Python Isolation**: Creates a local virtual environment (venv) with dedicated libraries (scapy, pwntools, pycryptodome) to keep the system clean.

* **Spotify Patching**: Unlocks root permissions for the app and injects the Spicetify Marketplace script.

### 2. Hyprland (Window Manager)

The entire window manager logic is located in the dotfiles/hyprland/.config/hypr/ directory. Here is exactly where to go for specific modifications:

* **Colors & Themes:**
    * **File: dotfiles/hyprland/.config/hypr/colors.conf**
    * **What to change: You will find the RGB variables for the Catppuccin Mocha theme (e.g., $mauve, $blue, $red). Change the values here to overhaul the colors of borders and interfaces all at once.**

* **Monitors & Resolution:**
    * **File: hyprland.conf (Section 2)**
    * **What to change: Edit the line monitor=,highres,auto,1. If you have multiple monitors or want to adjust refresh rates/scaling, this is the place.**

* **Keybindings:**
    * **File: hyprland.conf (Section 8)**
    * **What to change: Look for all macros starting with bind. For example, to change the default terminal or the launcher (Wofi), find the lines with $mainMod, RETURN or $mainMod, D.**

* **Aesthetics (Gaps, Borders, Rounding):**
    * **File: hyprland.conf (Sections 4 & 5)**
    * **What to change: Modify gaps_in (spacing between windows), gaps_out (spacing from screen edges), or rounding to change the corner radius.**

* **Autostart Apps:**
    * **File: hyprland.conf (Section 7)**
    * **What to change: Look for lines starting with exec-once. If you want an app (e.g., Discord or a Browser) to open automatically upon login, add it here.**

### 3. Waybar (Status Bar) - Detailed Analysis (English)

The top status bar is entirely configured within the dotfiles/waybar/.config/waybar/ directory. Here are the key files:

* **Module Logic & Structure:**
    * **File: dotfiles/waybar/.config/waybar/config**
    * **What to change: This JSON file defines the order and behavior of the modules.**
        * **Positioning: Edit the "modules-left", "modules-center", or "modules-right" arrays to rearrange elements like the workspaces, clock, or battery.**
        * **Interactivity: Many modules have click actions. For example, clicking the CPU or RAM modules opens the btop system monitor in the Foot terminal. The "custom/power" module is configured to launch wlogout for power management.**

* **Style, Colors & Fonts:**
    * **File: dotfiles/waybar/.config/waybar/style.css**
    * **What to change: Uses standard CSS syntax.**
        * **Catppuccin Theme: References Mocha colors, including a background with 90% transparency (rgba(30, 30, 46, 0.9)) and Mauve accents for the clock and active workspaces.**
        * **Font: Currently set to JetBrainsMono Nerd Font at 14px. Change this to use any font installed on your system.**
        * **System Alerts: The battery module has a specific .critical class that turns red (#f38ba8) when the charge is low.**

### 4. Foot & Zsh (Terminal & Shell)
This section covers the command-line interface, optimized for speed and utility during programming or security sessions.

* **Foot Terminal:**
    * **File:** `dotfiles/foot/.config/foot/foot.ini`
    * **What to change:**
        * **Aesthetics:** The opacity (alpha) is set to `0.9` for a semi-transparent "glass" effect. Colors strictly follow the Catppuccin Mocha palette.
        * **Font:** Uses `JetBrainsMono Nerd Font` size `11`. You can modify the `font=` line to change the typeface or size.
        * **Padding:** Internal margins are set to `15x15` to ensure text doesn't touch the window edges.
* **Zsh Configuration:**
    * **File:** `dotfiles/zsh/.zshrc`
    * **What to change:**
        * **Custom Aliases:** Includes shortcuts like `v` for Neovim, `fast` for Fastfetch, and the `update` command which synchronizes both official repositories and the AUR (`sudo pacman -Syu && yay -Sua`).
        * **CyberChallenge Integration:** Automatically adds the Python virtual environment path (`venv/bin`) to your `$PATH`, making security tools available globally.
        * **Framework:** Configured with Oh My Zsh using the `robbyrussell` theme, with plugins enabled for autosuggestions and syntax highlighting.

### 5. Neovim (Text Editor) - English Version
A modern, Lua-based configuration focused on performance and the Catppuccin aesthetic.

* **Plugin Management:**
    * **File:** `dotfiles/nvim/.config/nvim/init.lua`
    * **What to change:** Uses `Lazy.nvim` as the plugin manager. It automatically installs `catppuccin` for the theme and `nvim-treesitter` for advanced syntax highlighting.
* **Global Options:**
    * Features include relative line numbers for faster jumping, system clipboard synchronization (`unnamedplus`), and smart case-sensitive searching.
* **Keybindings:**
    * Uses **Space** as the leader key.
    * `<leader>w`: Save file.
    * `<leader>q`: Quit.
    * `Ctrl + h/j/k/l`: Professional window navigation.

### 6. Fastfetch (System Information) - English Version
Provides a clean, styled overview of your system stats whenever you open the terminal.

* **Visuals:**
    * **Files:** `dotfiles/fastfetch/.config/fastfetch/config.jsonc` and `wolf.txt`
    * **What to change:** Uses a custom ASCII wolf logo found in `wolf.txt`.
* **Modules:**
    * Displays OS, Kernel, Package count, WM, Terminal info, and RAM usage.
    * The colors are themed in Magenta (Mauve) and Blue to match the rest of the system.

### 7. Python Virtual Environment (Cyber-Security Tools) - English Version
A dedicated environment for cyber-security and CyberChallenge preparation.

* **Location:** `$HOME/arch-hypr-rice/venv/`
* **Details:** The install script automatically creates this virtual environment to keep your system Python clean.
* **Pre-installed Libraries:** Includes `requests`, `scapy`, `pwntools`, and `pycryptodome`.
* **Usage:** These tools are added to your shell path via `.zshrc`, allowing you to run them instantly in any terminal session.

### 🎵 Spotify & Spicetify (Marketplace) - English Version
*Already provided, but included here for the complete flow:*

On a fresh installation, Spicetify might not inject the Marketplace automatically because Spotify needs to be launched at least once to create its internal configuration files. 

If you don't see the Marketplace (shopping cart icon) after running the install script:
1.  Open **Spotify** from your app launcher.
2.  Close it completely.
3.  Open your terminal and run:
   
    ```bash
    spicetify backup apply
    curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
    ```

5.  Restart Spotify. The Marketplace will now be available!

---

## 🛠️ Troubleshooting

If the installation fails or something doesn't work, don't panic. The script automatically saves a detailed log file named `install_progress.log` in the root directory. 
Open it with any text editor to see exactly which command or package caused the error.

### 🚑 Troubleshooting A.

Corrupted packages, timeouts, or network errors during installation?
If the installation stops abruptly (e.g., due to a slow mirror or a sudden network disconnection), you might end up with partial or corrupted files in your pacman cache. If the script keeps failing or throws reading errors (like Error reading fd 7), do a complete cache cleanup before trying again:

 ```bash
sudo pacman -Scc
```

> [!WARNING]
> Answer Y to all terminal prompts to empty the cache, then restart the installation with ./install.sh. Use this command only as an emergency step to unblock the setup, as it wipes out all saved package versions and will prevent you from doing a quick downgrade in the future if an update breaks your system.

### 🚑 Troubleshooting B.

 ```bash
nmtui
```

---

## 📜 License

This project is licensed under the **MIT License** (Copyright (c) 2026 Tony-ScarFace). Feel free to use, modify, and distribute this code as you see fit.

---

