# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ inputs, config, pkgs, system-stateVersion, system, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    # ncdu
    # tmux
    # htop
    # bandwhich
  ];

  # clean journalctl

  # services.cron = {
  #     enable = true;
  #     systemCronJobs = [
  #       "0 0 * * * journalctl --vacuum-time=7d 1>/dev/null" // Clean up journal logs every week
  #     ];
  #   };

  # garbange collection check https://nixos.wiki/wiki/Nix_Cookbook#Reclaim_space_on_Nix_install.3F
  # nix.gc.automatic = true;
  # nix.settings.auto-optimise-store = true;

  system.stateVersion = system-stateVersion; # Did you read the comment?
}
