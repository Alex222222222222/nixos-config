{ nixpkgs, inputs, config, pkgs, system-stateVersion, system, ... }:
let
  # configure for cross compilation on linux
  # pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
  # pkgs = nixpkgs.legacyPackages.${system};
  filesystems = pkgs.lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
    /* "zfs" */
    "ext4"
    "vfat"
  ];
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

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

  hardware.deviceTree = {
    enable = true;
    filter = "sun50i-h616-orangepi-zero2.dtb";
    overlays = [
      {
        name = "sun50i-h616-orangepi-zero2.dtb";
        dtsText = ''
          /dts-v1/;
          /plugin/;

          / {
            compatible = "xunlong,orangepi-zero2", "allwinner,sun50i-h616";
          };

          &ehci0 {
            status = "okay";
          };

          &ehci1 {
            status = "okay";
          };

          &ehci2 {
            status = "okay";
          };

          &ehci3 {
            status = "okay";
          };

          &ohci0 {
            status = "okay";
          };

          &ohci1 {
            status = "okay";
          };

          &ohci2 {
            status = "okay";
          };

          &ohci3 {
            status = "okay";
          };
        '';
      }
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Disable ZFS support to prevent problems with fresh kernels.
  boot.supportedFilesystems = filesystems;
  boot.initrd.supportedFilesystems = filesystems;
}
