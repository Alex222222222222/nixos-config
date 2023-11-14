{config, inputs, system, ...}:
{
  imports = [
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${system}.default
  ];

  age.secrets = {
    hetzner-webdav-secrets = {
      file = ./hetzner-webdav-secrets;
      owner = "root";
      group = "root";
      mode = "600";
    };
    cloudflare-email-api-key = {
      file = ./cloudflare-email-api-key;
      owner = "root";
      group = "root";
      mode = "600";
    };
    v2ray-config = {
      file = ./v2ray-config;
      owner = "root";
      group = "root";
      mode = "600";
    };

    hysteria-obfs.file = ./hysteria-obfs;
    hysteria-alpn.file = ./hysteria-alpn;

    tailscale-key.file = ./tailscale-key;
    
    postgresql-freshrss-pass.file = ./postgresql-freshrss-pass;

    cloudme-webdav-secrets.file = ./cloudme-webdav-secrets;

    freshrss_tunnel_token = {
      file = ./freshrss_tunnel_token;
      owner = "cloudflared";
      group = "cloudflared";
      mode = "600";
    };
  };
}
