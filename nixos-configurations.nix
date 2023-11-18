{ inputs, nixpkgs, home-manager, agenix, rust-overlay, ... }:
let system-stateVersion = "23.05";
in {
  racknerd = let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = { inherit inputs pkgs system-stateVersion system; };

    modules = [
      ./app/ssh-keys.nix

      ./secrets/secrets-path.nix
      agenix.nixosModules.default

      ./machine/racknerd/hardware-configuration.nix
      ./machine/racknerd/configuration.nix
      ./machine/racknerd/networking.nix

      ./app/docker/docker.nix
      ./app/tailscale/tailscale.nix

      ./app/postgresql/postgresql.nix

      ./app/webdav/hetzner.nix

      ./app/freshrss/freshrss.nix
    ];
  };

  server-factory = let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = { inherit inputs pkgs system-stateVersion system; };

    modules = [
      ./app/ssh-keys.nix

      ./secrets/secrets-path.nix
      agenix.nixosModules.default

      ./machine/server-factory /hardware-configuration.nix
      ./machine/server-factory /configuration.nix
      ./machine/server-factory /networking.nix

      ./app/docker/docker.nix
      ./app/tailscale/tailscale.nix

      ./app/webdav/hetzner.nix
    ];
  };
}
