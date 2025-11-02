# ...existing code...
#!/usr/bin/env bash
set -euo pipefail

REPO_KEY="/usr/share/keyrings/tailscale-archive-keyring.gpg"
REPO_LIST="/etc/apt/sources.list.d/tailscale.list"
DIST="bookworm"

# Download GPG key if not present
if [ ! -f "$REPO_KEY" ]; then
  sudo mkdir -p "$(dirname "$REPO_KEY")"
  curl -fsSL "https://pkgs.tailscale.com/stable/debian/${DIST}.noarmor.gpg" | sudo tee "$REPO_KEY" >/dev/null
fi

# Add APT source list (idempotent)
if [ ! -f "$REPO_LIST" ] || ! grep -q "pkgs.tailscale.com" "$REPO_LIST"; then
  echo "deb [signed-by=${REPO_KEY}] https://pkgs.tailscale.com/stable/debian ${DIST} main" | sudo tee "$REPO_LIST" >/dev/null
fi

# Update and install package
sudo apt-get update
sudo apt-get install -y tailscale

# Enable and start the service, fail with status if it doesn't start
if ! sudo systemctl enable --now tailscaled.service; then
  echo "Failed to enable/start tailscaled.service. Showing status:"
  sudo systemctl status tailscaled.service --no-pager || true
  exit 1
fi

# Get authkey from arg or env var
AUTHKEY="${1:-${TAILSCALE_AUTHKEY:-}}"

if [ -z "$AUTHKEY" ]; then
  echo "Tailscale installed and service started. No authkey provided."
  echo "To connect, run: sudo tailscale up --ssh --authkey=tskey-...  (or set TAILSCALE_AUTHKEY env var / pass as first arg)"
  exit 0
fi

# Bring interface up
sudo tailscale up --ssh --authkey="$AUTHKEY"
# ...existing code...
