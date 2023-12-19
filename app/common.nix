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
}
