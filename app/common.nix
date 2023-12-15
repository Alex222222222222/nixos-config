{ config, pkgs, ... }: {
  imports = [ ./clean_up.nix ./nameservers.nix ./ssh-keys.nix ];
}
