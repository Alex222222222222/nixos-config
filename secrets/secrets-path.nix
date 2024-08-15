{ config, inputs, system, ... }: {
  imports = [ ];

  environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

  age.secrets = {
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

    freshrss_tunnel_token = {
      file = ./freshrss_tunnel_token;
      owner = "cloudflared";
      group = "cloudflared";
    };

    k3s-common-secret = { file = ./k3s-common-secret; };

    k3s-tailscale = { file = ./k3s-tailscale; };

    pass-3proxy = { file = ./pass-3proxy; };

    scylla_proxy_tunnel_token = {
      file = ./scylla_proxy_tunnel_token;
      owner = "cloudflared";
      group = "cloudflared";
    };
    scylla_webui_tunnel_token = {
      file = ./scylla_webui_tunnel_token;
      owner = "cloudflared";
      group = "cloudflared";
    };
  };
}
