{
  description = "Alex222222222222 configuration for arm64 nix os";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
    ];

    # nix community's cache server
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs 即 flake 的所有输出，其中的 nixosConfigurations 即 NixOS 系统配置
  # 一个 flake 可以有很多用途，也可以有很多种不同的输出，nixosConfigurations 只是其中一种
  # 
  # outputs 的参数都是 inputs 中定义的依赖项，可以通过它们的名称来引用。
  # 不过 self 是个例外，这个特殊参数指向 outputs 自身（自引用），以及 flake 根目录
  # 这里的 @ 语法将函数的参数 attribute set 取了个别名，方便在内部使用 
  outputs = { self, nixpkgs, home-manager, agenix, rust-overlay,... }@inputs: {
    devShells = 
      let
        overlays = [ rust-overlay.overlay ];
        # System types to support.
        supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
        forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        # Nixpkgs instantiated for supported system types.
        nixpkgsFor = forAllSystems (system: import nixpkgs { inherit overlays system; });
      in
      forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
          commonBuildInputs = [
              inputs.agenix.packages.${system}.default
              pkgs.tailscale
              pkgs.unzip
              pkgs.git
              pkgs.curl
              pkgs.wget
              pkgs.ncdu
              pkgs.bandwhich
              pkgs.vscode
              pkgs.neovim
              pkgs.smartmontools
          ];
          commonShellHook = ''
            export EDITOR=nvim
            export VISUAL=nvim
            export PATH=$PATH:$HOME/.local/bin
          '';
          rust = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
	   
	  R-with-my-packages = pkgs.rWrapper.override{
            packages = with pkgs.rPackages; [ ggplot2 dplyr xts ]; 
          };
        in
        {
          # The default package for 'nix build'. This makes sense if the
          # flake provides only one package or there is a clear "main"
          # package.
          default = pkgs.mkShell {
            buildInputs = commonBuildInputs;
            shellHook = commonShellHook;
          };
          ffmpeg = pkgs.mkShell {
            buildInputs = commonBuildInputs ++ [
              pkgs.ffmpeg-full
            ];
            shellHook = commonShellHook;
          };
          latex = pkgs.mkShell {
            buildInputs = commonBuildInputs ++ [
              pkgs.texlive.combined.scheme-full
            ];
            shellHook = commonShellHook;
          };
          # Also see https://www.tomhoule.com/2021/building-rust-wasm-with-nix-flakes/
          rust = pkgs.mkShell {
            buildInputs = commonBuildInputs ++ [
              pkgs.rust-analyzer
              pkgs.rustfmt
              # pkgs.cargo
              # pkgs.rustc
              # pkgs.nodePackages_latest.tailwindcss
              pkgs.cargo-tauri
              pkgs.trunk
              # pkgs.rustup
              pkgs.wasm-bindgen-cli
              pkgs.wasm-pack
              pkgs.binaryen
              pkgs.protobuf
              rust
            ];
            shellHook = commonShellHook;
          };
	  R = pkgs.mkShell {
	    buildInputs = commonBuildInputs ++ [
	      R-with-my-packages
	      pkgs.pandoc
	      pkgs.texlive.combined.scheme-full
	    ];
	    shellHook = commonShellHook;
	  };
        }
      );
    
    # 名为 nixosConfigurations 的 outputs 会在执行 `nixos-rebuild switch --flake .` 时被使用
    # 默认情况下会使用与主机 hostname 同名的 nixosConfigurations，但是也可以通过 `--flake .#<name>` 来指定
    nixosConfigurations = {
      hetzner = 
      let
        system-stateVersion = "23.05";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system}; 
      in
      nixpkgs.lib.nixosSystem {
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
            home-manager.users.zifan = import ./zifan/default.nix ;
            # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
            # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
            home-manager.extraSpecialArgs = { inherit inputs pkgs system-stateVersion; };
          }
        ];
      };

      racknerd =
      let
        system-stateVersion = "23.05";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      nixpkgs.lib.nixosSystem {
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

      vultr =
      let
        system-stateVersion = "23.05";
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      nixpkgs.lib.nixosSystem {
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

      # hostname 为 nixos-test 的主机会使用这个配置
      # 这里使用了 nixpkgs.lib.nixosSystem 函数来构建配置，后面的 attributes set 是它的参数
      # 在 nixos 系统上使用如下命令即可部署此配置：`nixos-rebuild switch --flake .#nixos-test`
      # m1-qemu-virtual-machine = nixpkgs.lib.nixosSystem {
        # system = "aarch64-linux";
        # specialArgs = { inherit inputs; };

        # modules 中每个参数，都是一个 Nix Module，nixpkgs manual 中有半份介绍它的文档：
        #    <https://nixos.org/manual/nixpkgs/unstable/#module-system-introduction>
        # 说半份是因为它的文档不全，只有一些简单的介绍（Nix 文档现状...）
        # Nix Module 可以是一个 attribute set，也可以是一个返回 attribute set 的函数
        # 如果是函数，那么它的参数就是当前的 NixOS Module 的参数.
        # 根据 Nix Wiki 对 Nix modules 的描述，Nix modules 函数的参数可以有这四个（详见本仓库中的 modules 文件）：
        # 
        #  config: The configuration of the entire system
        #  options: All option declarations refined with all definition and declaration references.
        #  pkgs: The attribute set extracted from the Nix package collection and enhanced with the nixpkgs.config option.
        #  modulesPath: The location of the module directory of NixOS.
        #
        # 默认只能传上面这四个参数，如果需要传其他参数，必须使用 specialArgs
        # nix flake 的 modules 系统可将配置模块化，提升配置的可维护性
        # modules = [
          # 导入之前我们使用的 configuration.nix，这样旧的配置文件仍然能生效
          # 注：configuration.nix 本身也是一个 NixOS Module，因此可以直接在这里导入
          # ./m1-qemu-virtual-machine/configuration.nix

          # home-manager.nixosModules.home-manager
          # {
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;

            # 这里的 ryan 也得替换成你的用户名
            # 这里的 import 指令在前面 Nix 语法中介绍过了，不再赘述
            # home-manager.users.zifan = import ./zifan/default.nix ;
            # 使用 home-manager.extraSpecialArgs 自定义传递给 ./home.nix 的参数
            # 取消注释下面这一行，就可以在 home.nix 中使用 flake 的所有 inputs 参数了
            # home-manager.extraSpecialArgs = inputs;
          # }
        # ];
      # };
    };
  };
}
