{config, ...}:
let
  web-domain = "search.huazifan.eu.org";
  web-port = "9080";
in
{
  environment.etc = {
    # "searxng/settings.yml".source = ./settings.yml;
    # "searxng/uwsgi.ini".source = ./uwsgi.ini;
  };

  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    searx = {
      image = "searx/searx";
      autoStart = true;
      ports = [ "127.0.0.1:${web-port}:8080" ];
      environment = {
        BASE_URL = "https://${web-domain}/";
        INSTANCE_NAME = "HuaSearch";
      };
      volumes = [
        "/etc/searx:/etc/searx"
      ];
      extraOptions = [
      ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "huazifan@gmail.com";
    certs.${web-domain} = {
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-email-api-key.path;
      group = config.services.nginx.group;
    };
  };

  services.nginx = {
    enable = true;

    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    virtualHosts.${web-domain} = {
      forceSSL = true;
      useACMEHost = web-domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${web-port}";

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
