{
  description = "Build image for OrangePi Zero 2";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-23.05;
  };
  outputs = { self, nixpkgs }: let
    system = "aarch64-linux";

    #Build manipulation
    stateVersion = "23.05";   # NixOS Version
    compressImage = true;     # Set to false to disable image compressing

    # configure for cross compilation on aarch64-darwin
    pkgs = nixpkgs.legacyPackages.aarch64-darwin-linux.pkgsCross.aarch64-multiplatform;

    # Boot related configuration
    bootConfig = let
      bootloaderPackage = pkgs.ubootOrangePiZero2;
      bootloaderSubpath = "/u-boot-sunxi-with-spl.bin";
      # Disable ZFS support to prevent problems with fresh kernels.
      filesystems = pkgs.lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs"
                                       "ntfs" "cifs" /* "zfs" */ "ext4" "vfat"
                                     ];
    in {
      system.stateVersion = stateVersion;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.supportedFilesystems = filesystems;
      boot.initrd.supportedFilesystems = filesystems;
      sdImage = {
        postBuildCommands = ''
          # Emplace bootloader to specific place in firmware file
          dd if=${bootloaderPackage}${bootloaderSubpath} of=$img    \
            bs=8 seek=1024                                          \
            conv=notrunc # prevent truncation of image
        '';
        inherit compressImage;
      };
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
    };

    # NixOS configuration
    nixosSystem = nixpkgs.lib.nixosSystem rec {
      inherit system;
      modules = [
        # Default aarch64 SOC System
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        # Minimal configuration
        "${nixpkgs}/nixos/modules/profiles/minimal.nix"
        { config = bootConfig; }
        # Put your configuration here. e.g. ./configuration.nix
      ];
    };
  in {
    inherit system;
    # Run nix build .#images.orangePiZero2 to build image.
    images = {
      orangePiZero2 = nixosSystem.config.system.build.sdImage;
    };
  };
}