{ config, inputs, system, ... }: {
  imports = [ ];

  environment.systemPackages = [ inputs.agenix.packages.${system}.default ];

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

    cockroach-ca-crt = {
      file = ./cockroach/certs/ca.crt;
      owner = "cockroachdb";
      group = "cockroachdb";
      path = "/var/lib/cockroach/certs/ca.crt";
    };
    cockroach-node-crt = {
      file = ./cockroach/certs/node.crt;
      owner = "cockroachdb";
      group = "cockroachdb";
      path = "/var/lib/cockroach/certs/node.crt";
    };
    cockroach-node-key = {
      file = ./cockroach/certs/node.key;
      owner = "cockroachdb";
      group = "cockroachdb";
      path = "/var/lib/cockroach/certs/node.key";
    };
  };
}
