{ ... }:
{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.usePredictableInterfaceNames = false;
  networking.dhcpcd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable mosh, the ssh alternative when client has bad connection
  # Opens UDP ports 60000 ... 61000
  programs.mosh.enable = true;
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 60000;
      to = 61000;
    }
  ];

  networking.firewall = {
    enable = true;
    # Allow connections from the local network.
    allowedTCPPorts = [ 22 23 80 443 53 config.services.tailscale.port ];
    allowedUDPPorts = [ 22 23 80 443 53 config.services.tailscale.port ];
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
  };
}
