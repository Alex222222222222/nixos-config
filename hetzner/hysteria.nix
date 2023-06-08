{config, ...}:
{
  services.hysteria = {
    enable = true; 
    port = 36712; 
    protocol = "wechat-video"; # "udp", "wechat-video", "faketcp". Empty = "udp"
    domain = "vtb.asdfghjk.eu.org";
    acme-cloudflare-secret = config.age.secrets.cloudflare-email-api-key.path;
    obfs = config.age.secrets.hysteria-obfs.path;
    alpn = config.age.secrets.hysteria-alpn.path;
    acme-email = "huazifan@gmail.com";
  };
  # networking.firewall.allowedTCPPorts = [ 22 23 80 443 53 36712 ];
  # networking.firewall.allowedUDPPorts = [ 22 23 80 443 53 36712 ];
}
