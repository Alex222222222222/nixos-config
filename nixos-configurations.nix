{ inputs, nixpkgs, home-manager, agenix, rust-overlay, ... }:
let system-stateVersion = "23.05";
in {
  hetzner = let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = { inherit inputs pkgs system-stateVersion system; };

    modules = [
      ./machine/hetzner/hardware-configuration.nix

      ./secrets/secrets-path.nix
      agenix.nixosModules.default

      ./machine/hetzner/configuration.nix
      ./machine/hetzner/hetzner-webdav.nix
      ./machine/hetzner/networking.nix
      ./machine/hetzner/v2ray.nix
      ./machine/hetzner/freshrss.nix
      ./machine/hetzner/searxng/searxng.nix

      ./app/docker/docker.nix
      ./app/tailscale/tailscale.nix

      inputs.hysteria.nixosModules.with-cloudflare-acme
      ./machine/hetzner/hysteria.nix

      inputs.jellyfin.nixosModules.with-nginx-cloudlfare-acme
      ./machine/hetzner/jellyfin.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        # 这里的 ryan 也得替换成你的用户名
        # 这里的 import 指令在前面 Nix 语法中介绍过了，不再赘述
        home-manager.users.zifan = import ./zifan/default.nix;
        # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
        # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
        home-manager.extraSpecialArgs = {
          inherit inputs pkgs system-stateVersion;
        };
      }
    ];
  };

  racknerd = let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = { inherit inputs pkgs system-stateVersion system; };

    modules = [
      ./secrets/secrets-path.nix
      agenix.nixosModules.default

      ./machine/racknerd/hardware-configuration.nix
      ./machine/racknerd/configuration.nix
      ./machine/racknerd/networking.nix

      ./app/docker/docker.nix
      ./app/tailscale/tailscale.nix
    ];
  };

  vultr = let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in nixpkgs.lib.nixosSystem {
    system = system;

    specialArgs = { inherit inputs pkgs system-stateVersion system; };

    modules = [
      ./secrets/secrets-path.nix
      agenix.nixosModules.default

      ./machine/vultr/hardware-configuration.nix
      ./machine/vultr/configuration.nix
      ./machine/vultr/networking.nix

      ./app/tailscale/tailscale.nix
    ];
  };
}
