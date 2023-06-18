{...}:
{
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager = {
  #   enable = true;
  #
  # };  # Easiest to use and most distros use this by default.
  networking.usePredictableInterfaceNames = false;
  networking.dhcpcd.enable = true;
  systemd.network = {
    enable = true;
    networks."eth0".extraConfig = ''
      [Match]
      Name = eth0
      [Network]
      # Add your own assigned ipv6 subnet here here!
      Address = 2a01:4f9:c012:4dbf::/64
      Gateway = fe80::1
      # optionally you can do the same for ipv4 and disable DHCP (networking.dhcpcd.enable = false;)
      # Address =  144.x.x.x/26
      # Gateway = 144.x.x.1
    '';
  };
  networking.nameservers = [
    # google dns
    "8.8.8.8"
    "8.8.4.4"
    "2001:4860:4860::8888"
    "2001:4860:4860::8844"
    "2001:4860:4860:0:0:0:0:8888"
    "2001:4860:4860:0:0:0:0:8844"
    # cloudflare dns
    "1.1.1.1"
    "2606:4700:4700::1111"
    "1.0.0.1"
    "2606:4700:4700::1001"
    # cloudflare dns block malware
    "1.1.1.2"
    "1.0.0.2"
    "2606:4700:4700::1112"
    "2606:4700:4700::1002"
    # cloudflare dns block malware and adult content
    "1.1.1.3"
    "1.0.0.3"
    "2606:4700:4700::1113"
    "2606:4700:4700::1003"
  ];

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
  networking.firewall.allowedTCPPorts = [ 22 23 80 443 53 ];
  networking.firewall.allowedUDPPorts = [ 22 23 80 443 53 ];
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
      "8.8.8.8"
    ];
  };
}
