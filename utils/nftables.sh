#!/bin/bash

# Setup NFTables firewall with SSH only over Tailscale

set -e

# Install UFW if not present
if ! command -v nftables &>/dev/null; then
  echo "Installing nftables..."
  sudo pacman -S --needed --noconfirm nftables
fi

echo "Writing nftables.conf"
sudo tee /etc/nftables.conf >/dev/null <<'EOF'
flush ruleset

table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif "lo" accept
    ct state established,related accept
    iif tailscale0 tcp dport 22 accept
    iif tailscale0 tcp dport {22000,42697} accept
    iif tailscale0 udp dport {22000,21027} accept
  }
  chain forward { type filter hook forward priority 0; policy accept; }
  chain output  { type filter hook output  priority 0; policy accept; }
}
EOF

# Enable UFW service to start on boot
echo "Enabling nftables service..."
sudo systemctl enable nftables.service
sudo systemctl start nftables.service

# Show status
echo "nftables Status:"
sudo nft list ruleset

echo "nft setup complete"
