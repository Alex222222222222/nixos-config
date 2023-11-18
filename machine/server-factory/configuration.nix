# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [
      "${builtins.readFile ./key}"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "${builtins.readFile ./key}"
  ];
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    ncdu
    tmux
    htop
    bandwhich
  ];

  networking = {
    dhcpcd.enable = false;
    # usePredictableInterfaceNames = false;
    interfaces = {
      eth0.ipv6.addresses = [{
        address = "2a07:e042:1:b4::1";
        prefixLength = 32;
      }];
    };
    defaultGateway6 = {
      address = "2a07:e042::1";
      interface = "eth0"; 
    };
    nameservers = [
      "2001:67c:2b0::4"
      "2001:67c:2b0::6"
      "2a01:4f9:c010:3f02::1"
      "2a00:1098:32c:1"
    ];
    firewall.enable = false;
  };

  services.openssh.enable = true;
  programs.mosh.enable = true;


  system.stateVersion = "23.05"; # Did you read the comment?

}

