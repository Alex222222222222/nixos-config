{config, pkgs, ...}:
{
  services.jellyfin = {
    enable = true;
    web-domain = "jellyfin.huazifan.eu.org";
    acme-email = "huazifan@gmail.com";
    cloudflare-email-api-key = config.age.secrets.cloudflare-email-api-key.path; 
  };
}
