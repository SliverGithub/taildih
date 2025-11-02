curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo systemctl enable --now tailscaled

# Read auth key securely:
if [ -n "$TAILSCALE_AUTHKEY" ]; then
	KEY="$TAILSCALE_AUTHKEY"
elif [ -f /etc/tailscale/authkey ]; then
	# read as root to avoid permission issues
	KEY=$(sudo cat /etc/tailscale/authkey)
else
	echo "Error: TAILSCALE_AUTHKEY not set and /etc/tailscale/authkey not found."
	echo "Place the key in /etc/tailscale/authkey (root-only, chmod 600) or export TAILSCALE_AUTHKEY."
	exit 1
fi

# If using the file, ensure safe permissions
if [ -f /etc/tailscale/authkey ]; then
	sudo chown root:root /etc/tailscale/authkey
	sudo chmod 600 /etc/tailscale/authkey
fi

# Use the key (no hardcoded secret in the script)
sudo tailscale up --ssh --authkey="$KEY"
