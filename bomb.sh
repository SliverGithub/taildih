curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled
sudo tailscale up --ssh --authkey=tskey-auth-kALBhvex5A21CNTRL-bfpn7weiajSVuAPQmL31jSfhKCfiCj41