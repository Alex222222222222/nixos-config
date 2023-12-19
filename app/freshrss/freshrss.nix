{ inputs, config, pkgs, ... }:
let
  edge-ip-version = if config.networking.ipv6_only then "6" else "auto";
  freshrss-cloudflare-tunnel-script =
    pkgs.writeText "freshrss-cloudflare-tunnel-script" ''
      if [[ $(whoami) != "cloudflared" ]]; then
        exit 1;
      fi

      secret=$(cat "${config.age.secrets.freshrss_tunnel_token.path}")

      ${pkgs.cloudflared}/bin/cloudflared \
        --edge-ip-version=${edge-ip-version} \
        --post-quantum \
        tunnel --no-autoupdate run --token="$secret"
    '';
in {
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    freshrss = {
      image = "freshrss/freshrss";
      autoStart = true;
      ports = [ "127.0.0.1:8080:80" ];
      environment = { CRON_MIN = "1,31"; };
      volumes = [
        "freshrss_data:/var/www/FreshRSS/data"
        "freshrss_extensions:/var/www/FreshRSS/extensions"
      ];
      dependsOn = [ "freshrss-cloudflare-warp-proxy" ];
    };
    freshrss-cloudflare-warp-proxy = {
      image = "yarmak/warp-proxy";
      autoStart = true;
      ports = [ "0.0.0.0:39999:40000" ];
      extraOptions = [ ];
    };
  };

  users.groups.cloudflared = { };
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
    description = "cloudlfared tunnel user";
    useDefaultShell = true;
  };

  systemd.services.freshrss_tunnel = {
    description = "Cloudflare Tunnel for Selfhosted FreshRSS";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.bash}/bin/bash '${freshrss-cloudflare-tunnel-script}'";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
