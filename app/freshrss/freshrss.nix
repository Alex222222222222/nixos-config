{inputs, config, pkgs, ...}:
{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    freshrss = {
      image = "freshrss/freshrss";
      autoStart = true;
      ports = [ "127.0.0.1:8080:80" ];
      environment = {
        CRON_MIN="1,31";
      };
      volumes = [
          "freshrss_data:/var/www/FreshRSS/data"
          "freshrss_extensions:/var/www/FreshRSS/extensions"
      ];
      extraOptions = [
      ];
    };
  };

  systemd.services.freshrss_tunnel = {
    description = "Cloudflare Tunnel for Selfhosted FreshRSS";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=$(cat ${config.age.secrets.freshrss_tunnel_token.path})";
      Restart = "always";
      User = "root";
      Group = "root";
    };
  };
}
