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

  system.activationScripts."freshrss_cloudflare_tunnel_token" = ''
    secret=$(cat "${config.age.secrets.freshrss_tunnel_token.path}")
    configFile=/etc/postgresql/initial_script
    ${pkgs.gnused}/bin/sed -i "s#{{ FRESH_RSS_PASS }}#$secret#" "$configFile"
  '';

  environment.etc = {
    # Creates /etc/nanorc
    "freshrss/freshrss_cloudflare_tunnel" = {
      text = ''
        ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token={{ FRESH_RSS_PASS }})
      '';
      user = "cloudflared";
      group = "cloudflared";
      # The UNIX file mode bits
      mode = "0440";
    };
  };

  systemd.services.freshrss_tunnel = {
    description = "Cloudflare Tunnel for Selfhosted FreshRSS";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart = "/etc/freshrss/freshrss_cloudflare_tunnel";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
