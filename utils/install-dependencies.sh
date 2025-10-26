#!/bin/bash

PKGS=(
  # Hyprland stuff
  hyprland
  hyprshade
  hyprlock
  hypridle
  cpio

  foot
  grim
  chafa
  jq

  # Extra hyprland essentials
  polkit-gnome
  swaync
  waybar

  # Audio stuff
  pipewire
  wireplumber
  pipewire-alsa
  pipewire-pulse
  pipewire-audio
  pavucontrol

  # Bluetoothers
  blueman
  bluez
  bluez-utils

  selectdefaultapplication-git

  ctpv
  rsync
  7zip
  atool
  jq
  ffmpeg
  exiftool
  fzf
  fd
  bat

  # Fonts
  noto-fonts-cjk
  noto-fonts-emoji

  lf
  rofimoji
  wtype

  zoxide
  lsd

  # GTK theme optional
  adw-gtk-theme

  bc
  brightnessctl
  btop
  cava
  mpv
  imv
  cliphist
  cmatrix
  composer
  cowsay
  docker
  docker-compose
  eww
  fastfetch
  fcitx5
  fcitx5-gtk
  fcitx5-mozc
  fcitx5-qt
  fcitx5-rime
  ffmpegthumbnailer
  gnome-clocks
  gnome-disk-utility
  helvum
  kvantum-qt5
  man-db
  matugen-bin
  lazygit
  # localsend-bin
  luarocks
  papirus-icon-theme
  qt5-wayland
  qt6-wayland
  quickshell-git
  rofi
  ripgrep
  slurp
  stow
  swww
  udiskie
  tree
  ttf-jetbrains-mono-nerd
  uwufetch
  wl-clipboard

  wine
  winetricks
  wlogout
  wlsunset
  yubico-authenticator
  zen-browser-bin

  # NEEDS THEIR OWN SETUP SCRIPT
  flatpak
  fail2ban
  papirus-folders
  neovim # for my config
  ufw
  tailscale
  zsh
  openssh
  # winboat
  # firefoxpwa

  # Should be fine
  qt5ct
  qt6ct
  nwg-look
  kvantum
  fcitx5-configtool

  # Less necassary setup scripts
  proton-vpn-gtk-app
)

if command -v yay &>/dev/null; then
  yay -S --needed --noconfirm "${PKGS[@]}"
else
  echo "yay not found. Install yay first or remove AUR packages section."
  exit 1
fi
