{ inputs, nixpkgs, home-manager, agenix, rust-overlay, ... }:
let system-stateVersion = "23.11";
in {
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
