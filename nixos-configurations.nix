{ inputs, nixpkgs, home-manager, agenix, rust-overlay, ... }:
let system-stateVersion = "23.11";
in {
  racknerd =
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    nixpkgs.lib.nixosSystem {
      system = system;

      specialArgs = { inherit inputs pkgs system-stateVersion system; };

      modules = [
        ./app/common.nix

        ./secrets/secrets-path.nix
        agenix.nixosModules.default

        ./machine/racknerd/hardware-configuration.nix
        ./machine/racknerd/configuration.nix
        ./machine/racknerd/networking.nix

        ./app/webdav/hetzner.nix
      ];
    };

  orangePiZero2 =
    let
      system = "aarch64-linux";
      build_platform = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ipv6_only = false;
      compressImage = true; # Set to false to disable image compressing
      bootloaderPackage = pkgs.ubootOrangePiZero2;
      bootloaderSubpath = "/u-boot-sunxi-with-spl.bin";
    in
    nixpkgs.lib.nixosSystem {
      system = system;

      specialArgs = {
        inherit inputs pkgs system-stateVersion system ipv6_only nixpkgs;
      };

      modules = [
        {
          # nixpkgs.config.allowUnsupportedSystem = true;
          # nixpkgs.crossSystem.system = system;
          nixpkgs.hostPlatform.system = system;
          nixpkgs.buildPlatform.system =
            build_platform; # If you build on x86 other wise changes this.
          # ... extra configs as above

          sdImage = {
            postBuildCommands = ''
              # Emplace bootloader to specific place in firmware file
              dd if=${bootloaderPackage}${bootloaderSubpath} of=$img    \
                bs=8 seek=1024                                          \
                conv=notrunc # prevent truncation of image
            '';
            inherit compressImage;
          };
        }

        # Default aarch64 SOC System
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        # Minimal configuration
        "${nixpkgs}/nixos/modules/profiles/minimal.nix"

        ./app/common.nix

        ./secrets/secrets-path.nix
        agenix.nixosModules.default

        ./machine/orangepizero2/configuration.nix
        ./machine/orangepizero2/networking.nix

        ./app/networking/firewall.nix
      ];
    };

  server-factory =
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
    in
    nixpkgs.lib.nixosSystem {
      system = system;

      specialArgs = { inherit inputs pkgs system-stateVersion system; };

      modules = [
        ./app/common.nix

        ./secrets/secrets-path.nix
        agenix.nixosModules.default

        ./machine/server-factory/hardware-configuration.nix
        ./machine/server-factory/configuration.nix
        ./machine/server-factory/networking.nix
      ];
    };

  chicago =
    let
      # system = "i686-linux";
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ipv6_only = false;
    in
    nixpkgs.lib.nixosSystem {
      system = system;

      specialArgs = { inherit inputs pkgs system-stateVersion system ipv6_only; };

      modules = [
        ./app/common.nix

        ./secrets/secrets-path.nix
        agenix.nixosModules.default

        ./machine/chicago/hardware-configuration.nix
        ./machine/chicago/configuration.nix
        ./machine/chicago/networking.nix

        ./app/postgresql/postgresql.nix

        ./app/freshrss/freshrss.nix
        ./app/scylla.nix
      ];
    };

  macbookair =
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
      ipv6_only = false;
    in
    nixpkgs.lib.nixosSystem {
      system = system;

      specialArgs = { inherit inputs pkgs system-stateVersion system ipv6_only; };

      modules = [
        ./app/common.nix

        ./secrets/secrets-path.nix
        agenix.nixosModules.default

        ./machine/macbookair/gnome.nix
        ./machine/macbookair/hardware-configuration.nix
        ./machine/macbookair/configuration.nix
        ./machine/macbookair/networking.nix

        ./app/networking/firewall.nix

        ./app/docker/docker.nix
        ./app/tailscale/tailscale.nix
      ];
    };
}
