{ config, pkgs, ... }:
{
  # enable docker
  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  # Adding users to the docker group will provide them access to the socket:
  users.users.zifan.extraGroups = [ "podman" ];
  users.users.root.extraGroups = [ "podman" ];
}
