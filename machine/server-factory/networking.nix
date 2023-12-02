{...}:
{
  networking.hostName = "nixos"; # Define your hostname.

  networking = {
    dhcpcd.enable = false;
    # usePredictableInterfaceNames = false;
    interfaces = {
      eth0.ipv6.addresses = [{
        address = "2a07:e042:1:b4::1";
        prefixLength = 32;
      }];
    };
    defaultGateway6 = {
      address = "2a07:e042::1";
      interface = "eth0"; 
    };
  };

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

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 23 80 443 53 5332 53377 ];
  networking.firewall.allowedUDPPorts = [ 22 23 80 443 53 5332 53377 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

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
