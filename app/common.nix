{ config, pkgs, ... }: {
  imports = [
    ./clean_up.nix
    ./nameservers.nix
    ./ssh-keys.nix
    ./networking/firewall.nix
    ./docker/docker.nix
    ./tailscale/tailscale.nix
  ];

  users.groups.cloudflared = { };
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
    description = "cloudlfared tunnel user";
    useDefaultShell = true;
  };
}
