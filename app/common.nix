{ config, pkgs, ... }: {
  imports = [
    ./clean_up.nix
    ./nameservers.nix
    ./ssh-keys.nix
    ./networking/firewall.nix
    ./docker/docker.nix
    ./tailscale/tailscale.nix
    ./webdav/hetzner.nix
    ./socks5_server.nix
  ];

  users.groups.cloudflared = { };
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
    description = "cloudlfared tunnel user";
    useDefaultShell = true;
  };
}
