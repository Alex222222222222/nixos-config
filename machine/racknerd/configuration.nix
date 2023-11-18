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
  users.users.zifan.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local" # content of authorized_keys file
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local" # content of authorized_keys file
  ];

  # List packages installed in system profile. To search, run:
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

  # clean journalctl
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 0 * * * journalctl --vacuum-time=7d 1>/dev/null"
    ];
  };

  # garbange collection check https://nixos.wiki/wiki/Nix_Cookbook#Reclaim_space_on_Nix_install.3F
  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = system-stateVersion; # Did you read the comment?

}