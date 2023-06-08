{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  options = {
    services.jellyfin = {
      web-domain = mkOption {
        type = types.str;
        default = "example.com";
        description = lib.mdDoc "The domain you prepare to use";
      };

      cloudflare-email-api-key = mkOption {
        type = types.path;
        default = "";
        description = lib.mdDoc "Cloudflare api key for the acme";
      };

      acme-email = mkOption {
        type = types.str;
        default = "example@example.com";
        description = lib.mdDoc "Email used for the acme";
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.acme-email;
      certs.${cfg.web-domain} = {
        dnsProvider = "cloudflare";
        credentialsFile = cfg.cloudflare-email-api-key;
        group = config.services.nginx.group;
      };
    };

    services.nginx = {
      enable = true;

      virtualHosts.${cfg.web-domain} = {
        forceSSL = true;
        useACMEHost = cfg.web-domain;
        extraConfig = ''
          ## The default `client_max_body_size` is 1M, this might not be enough for some posters, etc.
          client_max_body_size 20M;

          # Security / XSS Mitigation Headers
          # NOTE: X-Frame-Options may cause issues with the webOS app
          add_header X-Frame-Options "SAMEORIGIN";
          add_header X-XSS-Protection "1; mode=block";
          add_header X-Content-Type-Options "nosniff";

          location = / {
            return 302 http://$host/web/;
            #return 302 https://$host/web/;
          }

          # location block for /web - This is purely for aesthetics so /web/#!/ works instead of having to go to /web/index.html/#!/
          location = /web/ {
              # Proxy main Jellyfin traffic
              proxy_pass http://127.0.0.1:8096/web/index.html;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Protocol $scheme;
              proxy_set_header X-Forwarded-Host $http_host;
          }
        '';

        locations."/" = {
          # Proxy main Jellyfin traffic
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };

        locations."/socket" = {
          # Proxy Jellyfin Websockets traffic
          proxyPass = "http://127.0.0.1:8096";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
          '';
        };
      };
    };
  };
}
