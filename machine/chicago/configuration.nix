# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{ inputs, config, pkgs, system-stateVersion, system, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    ncdu
    tmux
    htop
    bandwhich
  ];

  # clean journalctl
  services.cron = {
    enable = true;
    systemCronJobs = [ "0 0 * * * journalctl --vacuum-time=7d 1>/dev/null" ];
  };

  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;

  system.stateVersion = system-stateVersion; # Did you read the comment?
}
