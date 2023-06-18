{config, pkgs, ...}:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "huazifan@gmail.com";
    certs."vtc.asdfghjk.eu.org" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-email-api-key.path;
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;

    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    virtualHosts."vtc.asdfghjk.eu.org" = {
      forceSSL = true;
      useACMEHost = "vtc.asdfghjk.eu.org";
      extraConfig = ''
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      '';
      locations."/DJBwmPqvhxYGHyOh/" = { # Consistent with the path of V2Ray configurationi
        # proxyWebsockets = true; # needed if you need to use WebSocket
        proxyPass = "http://127.0.0.1:39998";

        extraConfig = ''
          if ($http_upgrade != "websocket") { # Return 404 error when WebSocket upgrading negotiate failed
                return 404;
          }
          proxy_redirect off;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
        '';
      };
    };
  };

  systemd.services.v2ray = {
    enable = true;
    description = "A v2ray server.";
    unitConfig = {
    };
    serviceConfig = {
      ExecStart = "${pkgs.v2ray}/bin/v2ray run -config ${config.age.secrets.v2ray-config.path}";
      Type = "simple";
    };
  };

  environment.systemPackages = [
    pkgs.v2ray
  ];
}
