{nixpkgs,...}:
let
  system = "aarch64-linux";

  #Build manipulation
  stateVersion = "23.05";   # NixOS Version
  compressImage = true;     # Set to false to disable image compressing

  # configure for cross compilation on linux
  pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;

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
    networking.hostName = "nixos"; # Define your hostname.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networking.usePredictableInterfaceNames = false;
    networking.dhcpcd.enable = true;

    networking.nameservers = [
      # google dns
      "8.8.8.8"
      "8.8.4.4"
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
      "2001:4860:4860:0:0:0:0:8888"
      "2001:4860:4860:0:0:0:0:8844"
      # cloudflare dns
      "1.1.1.1"
      "2606:4700:4700::1111"
      "1.0.0.1"
      "2606:4700:4700::1001"
      # cloudflare dns block malware
      "1.1.1.2"
      "1.0.0.2"
      "2606:4700:4700::1112"
      "2606:4700:4700::1002"
      # cloudflare dns block malware and adult content
      "1.1.1.3"
      "1.0.0.3"
      "2606:4700:4700::1113"
      "2606:4700:4700::1003"
    ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable mosh, the ssh alternative when client has bad connection
    # Opens UDP ports 60000 ... 61000
    programs.mosh.enable = true;
    networking.firewall.allowedTCPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
    networking.firewall.allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 23 80 443 53 5332 ];
    networking.firewall.allowedUDPPorts = [ 22 23 80 443 53 5332 ];
    # Or disable the firewall altogether.
    networking.firewall.enable = true;

    services.fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "127.0.0.0/8" 
        "10.0.0.0/8" 
        "172.16.0.0/12" 
        "192.168.0.0/16"
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
  orangePiZero2 = nixosSystem.config.system.build.sdImage;
}
