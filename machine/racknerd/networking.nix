{...}:
{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.usePredictableInterfaceNames = false;
  networking.dhcpcd.enable = true;

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
  networking.firewall.allowedTCPPorts = [ 22 23 80 443 53 5332 ];
  networking.firewall.allowedUDPPorts = [ 22 23 80 443 53 5332 ];
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
