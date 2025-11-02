#!/bin/bash
set -e  # Exit on any error

# Add Tailscale's repository and key
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# ✅ Install Tailscale
sudo apt-get update
sudo apt-get install -y tailscale

# Enable and start the tailscaled service
sudo systemctl enable --now tailscaled

# ✅ Use the auth key from the environment, making it available to sudo
# If your auth key is already set in your shell as TAILSCALE_AUTHKEY, this command passes it to the sudo environment.
sudo --preserve-env=TAILSCALE_AUTHKEY tailscale up --ssh --authkey="$TAILSCALE_AUTHKEY"
