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
  dns_options = if config.networking.ipv6_only then [
    "--dns"
    "2001:67c:2b0::4"
    "--dns"
    "2001:67c:2b0::6"
    "--dns"
    "2a01:4f9:c010:3f02::1"
    "--dns"
    "2a00:1098:32c::1"
    "--dns"
    "2001:4860:4860::64"
    "--dns"
    "2001:4860:4860::6464"
    "--dns"
    "2001:4860:4860:0:0:0:0:6464"
    "--dns"
    "2001:4860:4860:0:0:0:0:64"
    "--dns"
    "2606:4700:4700::64"
    "--dns"
    "2606:4700:4700::6400"
    "--dns"
    "2606:4700:4700:0:0:0:0:64"
    "--dns"
    "2606:4700:4700:0:0:0:0:6400"
    "--dns"
    "2a01:4f9:c010:3f02::1"
    "--dns"
    "2a00:1098:2b::1"
    "--dns"
    "2a01:4f8:c2c:123f::1"
    "--dns"
    "2001:67c:27e4::64"
    "--dns"
    "2001:67c:27e4:15::6411"
    "--dns"
    "2001:67c:27e4:15::64"
    "--dns"
    "2001:67c:27e4::60"
    "--dns"
    "2a03:7900:2:0:31:3:104:161"
    "--dns"
    "2602:fc23:18::7"
    "--dns"
    "2a00:1098:2c::1"
    "--dns"
    "2001:67c:2960::64"
    "--dns"
    "2001:67c:2960::6464"
    "--dns"
    "2001:67c:2b0::4"
    "--dns"
    "2001:67c:2b0::6"
    "--dns"
    "2a01:4f8:c2c:123f:69::1"
    "--dns"
    "2a00:1098:2b:0:69::1"
    "--dns"
    "2a01:4f9:c010:3f02:69::1"
  ] else
    [ ];
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
      dependsOn = [ ];
      extraOptions = [ ] ++ dns_options;
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
