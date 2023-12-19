{ config, ... }: {
  services._3proxy = {
    enable = true;
    services = [{
      type = "socks";
      auth = [ "strong" ];
      bindAddress = "0.0.0.0";
      bindPort = 39999;
      acl = [{
        rule = "allow";
        users = [ "zifan" ];
      }];
    }];
    usersFile = config.age.secrets.pass-3proxy.path;
  };

  netowrking.firewall.allowedTCPPorts = [ 39999 ];
  networking.firewall.allowedUDPPorts = [ 39999 ];
}
