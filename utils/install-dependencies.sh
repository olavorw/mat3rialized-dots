#!/bin/bash

# -------------------------------------------------------------
# 1. Hyprland / Wayland / Window‑manager essentials
# -------------------------------------------------------------
PKGS+=(
  hyprland   # core compositor
  hyprshade  # colour scheme for Hyprland
  hyprlock   # lock screen
  hypridle   # idle manager
  hyprfreeze # suspend/hibernate helper
  foot       # terminal emulator
  grim       # screenshot tool
  chafa      # ascii art renderer (for splash screens)
  jq         # JSON processor

  polkit-gnome # policy‑kit GUI for privileged actions
  swaync       # notification daemon
  # TODO: swayosd           # Sway on-screen display (shows volume adjustments, etc.) See https://github.com/ErikReider/SwayOSD
  waybar # status bar / widget area
)

# -------------------------------------------------------------
# 2. Audio & PipeWire stack
# -------------------------------------------------------------
PKGS+=(
  pipewire       # low‑latency audio server
  wireplumber    # modular session manager for PipeWire
  pipewire-alsa  # ALSA backend
  pipewire-pulse # PulseAudio compatibility layer
  pipewire-audio # generic audio support
  pavucontrol    # PulseAudio volume control (useful with pipewire‑pulse)
)

# -------------------------------------------------------------
# 3. Bluetooth stack
# -------------------------------------------------------------
PKGS+=(
  blueman     # GUI manager for Bluetooth devices
  bluez       # core Bluetooth protocol stack
  bluez-utils # command line utilities
)

# -------------------------------------------------------------
# 4. System & File utilities
# -------------------------------------------------------------
PKGS+=(
  syncthing                    # file sync tool (needs its own config)
  selectdefaultapplication-git # set default apps

  # ctpv              # terminal video player
  rsync    # file synchronization
  7zip     # compression / extraction
  atool    # archive viewer/manager
  ffmpeg   # multimedia framework
  exiftool # metadata editor
  fzf      # fuzzy finder
  fd       # find replacement
  bat      # cat clone with syntax highlighting

  lf       # file manager
  rofimoji # emoji picker for Rofi
  wtype    # X11/Wayland keyboard emulator

  zoxide # cd like a fish shell
  lsd    # ls alternative with colors
)

# -------------------------------------------------------------
# 5. Fonts & Icons
# -------------------------------------------------------------
PKGS+=(
  noto-fonts-cjk
  noto-fonts-emoji
  ttf-jetbrains-mono-nerd
  papirus-icon-theme
  papirus-folders # folder icons (needs its own setup)
)

# -------------------------------------------------------------
# 6. Graphics & Multimedia
# -------------------------------------------------------------
PKGS+=(
  mpv               # video player
  imv               # image viewer
  ffmpegthumbnailer # generate thumbnails for video files

  gnome-clocks       # clock application
  gnome-disk-utility # disk utility
)

# -------------------------------------------------------------
# 7. Audio tools & visualizers
# -------------------------------------------------------------
PKGS+=(
  helvum # audio mixer for PipeWire
  btop   # system monitor
  cava   # audio visualizer
)

# -------------------------------------------------------------
# 8. Command‑line utilities & helpers
# -------------------------------------------------------------
PKGS+=(
  bc                # arbitrary precision calculator
  brightnessctl     # adjust screen brightness
  cmatrix           # matrix effect
  composer          # PHP dependency manager (optional)
  cowsay            # ASCII cow
  docker            # container engine
  docker-compose    # compose files
  fastfetch         # system information tool
  fcitx5            # input method framework
  fcitx5-gtk        # GTK integration
  fcitx5-mozc       # Japanese IME
  fcitx5-qt         # Qt integration
  fcitx5-rime       # Rime engine
  fcitx5-configtool # configuration GUI

  eww            # widget toolkit (needs config)
  lazygit        # git UI
  luarocks       # Lua package manager
  quickshell-git # terminal shortcut launcher
  rofi           # application launcher / window switcher
  ripgrep        # grep replacement
  slurp          # selection tool for screenshots
  stow           # symlink manager
  swww           # wallpaper setter
  udiskie        # auto-mount removable media
  tree           # directory tree viewer
  wl-clipboard   # clipboard integration

  wine                 # Windows compatibility layer
  winetricks           # helper for Wine
  wlogout              # logout menu
  wlsunset             # sun‑time based color temperature
  yubico-authenticator # YubiKey OTP generator
  zen-browser-bin      # browser in a single binary (optional)

  zsh     # shell (needs own config)
  openssh # SSH client/server

  # -----------------------------------------------------------------
  # 9. Packages that need their own dedicated setup scripts
  # -----------------------------------------------------------------
  flatpak   # app sandboxing system
  fail2ban  # intrusion prevention
  neovim    # editor (for your custom config)
  ufw       # uncomplicated firewall
  tailscale # zero‑trust VPN
)

# -------------------------------------------------------------
# 10. GTK/Qt theme & appearance tools
# -------------------------------------------------------------
PKGS+=(
  adw-gtk-theme # modern GTK theme
  qt5ct         # Qt5 configuration tool
  qt6ct         # Qt6 configuration tool
  nwg-look      # look and feel settings for NWG apps
  kvantum       # Qt icon theme engine
  kvantum-qt5   # Qt5 support for Kvantum
)

# -------------------------------------------------------------
# 11. Miscellaneous / less necessary
# -------------------------------------------------------------
PKGS+=(
  proton-vpn-gtk-app # VPN client (optional)
)

# -------------------------------------------------------------
# End of PKGS array
# -------------------------------------------------------------

if command -v yay &>/dev/null; then
  yay -S --needed --noconfirm "${PKGS[@]}"
else
  echo "yay not found. Install yay first or remove AUR packages section."
  exit 1
fi
