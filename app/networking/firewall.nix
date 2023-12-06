{ config, ... }: {
  networking.firewall = {
    enable = true;
    # Allow connections from the local network.
    allowedTCPPorts = [ 22 23 80 443 53 ];
    allowedUDPPorts = [ 22 23 80 443 53 ];
    interfaces."tailscale0".allowedTCPPorts = [ 22 23 80 443 53 ];
  };
}
