{
  description = "Alex222222222222 configuration for arm64 nix os";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
    ];

    # nix community's cache server
    extra-substituters =
      [ "https://nix-community.cachix.org" "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager，用于管理用户配置
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # check https://nixos.wiki/wiki/Agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hysteria.url = "github:Alex222222222222/nixos-config?dir=/app/hysteria";
    hysteria.inputs.nixpkgs.follows = "nixpkgs";

    jellyfin.url = "github:Alex222222222222/nixos-config?dir=/app/jellyfin";
    jellyfin.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  # outputs 即 flake 的所有输出，其中的 nixosConfigurations 即 NixOS 系统配置
  # 一个 flake 可以有很多用途，也可以有很多种不同的输出，nixosConfigurations 只是其中一种
  # 
  # outputs 的参数都是 inputs 中定义的依赖项，可以通过它们的名称来引用。
  # 不过 self 是个例外，这个特殊参数指向 outputs 自身（自引用），以及 flake 根目录
  # 这里的 @ 语法将函数的参数 attribute set 取了个别名，方便在内部使用 
  outputs = { self, nixpkgs, home-manager, agenix, rust-overlay, ... }@inputs: rec {
    devShells = import ./dev-shells.nix { inherit inputs nixpkgs; };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;

    # 名为 nixosConfigurations 的 outputs 会在执行 `nixos-rebuild switch --flake .` 时被使用
    # 默认情况下会使用与主机 hostname 同名的 nixosConfigurations，但是也可以通过 `--flake .#<name>` 来指定
    nixosConfigurations = import ./nixos-configurations.nix {
      inherit inputs nixpkgs home-manager agenix rust-overlay;
    };

    # images
    images = {
      orangePiZero2 = nixosConfigurations.orangePiZero2.config.system.build.sdImage;
    };
  };
}
