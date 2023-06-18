{inputs, config, ...}:
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

  security.acme = {
    acceptTerms = true;
    defaults.email = "huazifan@gmail.com";
    certs."freshrss.huazifan.eu.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-email-api-key.path;
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;

    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    virtualHosts."freshrss.huazifan.eu.org" = {
      forceSSL = true;
      useACMEHost = "freshrss.huazifan.eu.org";
      # extraConfig = ''
      #   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      # '';
      locations."/" = { # Consistent with the path of V2Ray configurationi
        # proxyWebsockets = true; # needed if you need to use WebSocket
        proxyPass = "http://127.0.0.1:8080";

        extraConfig = ''
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
        '';
      };
    };
  };
}
