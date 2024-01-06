{ inputs, nixpkgs, ... }:
let
  overlays = [ inputs.rust-overlay.overlay ];
  # System types to support.
  supportedSystems =
    [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  # Nixpkgs instantiated for supported system types.
  nixpkgsFor =
    forAllSystems (system: import nixpkgs { inherit overlays system; });
in
forAllSystems (system:
let
  inherit (pkgs.stdenv) isLinux;

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
    pkgs.neovim
    pkgs.smartmontools
    pkgs.zstd
    pkgs.nixfmt
    pkgs.sqlite
    pkgs.tokei
    pkgs.mosh
    pkgs.rclone
    pkgs.docker
    pkgs.nmap
    # pkgs.heroku
    # pkgs.google-cloud-sdk
    # pkgs.awscli2
  ];
  localBuildInputs = [
    pkgs.gimp
    pkgs.vscode
    pkgs.nil
    pkgs.nixfmt
    pkgs.starship
    # pkgs.zulu
    pkgs.zulu8
  ];
  commonShellHook = ''
    export EDITOR=nvim
    export VISUAL=nvim
    export PATH=$PATH:$HOME/.local/bin
  '';

  rust-toolchain = pkgs.rust-bin.nightly.latest.default.override {
    extensions = [ "rust-analyzer" "rust-src" "rust-std" ];
    targets = [ "wasm32-unknown-unknown" ];
  };
  rust-packages-linux = with pkgs; [
    rust-toolchain
    nodejs-18_x
    nodePackages.pnpm
    pkg-config
    gtk3
    webkitgtk
    libayatana-appindicator.dev
    alsa-lib.dev
  ];
  rust-packages-darwin = with pkgs; [
    rust-toolchain
    nodejs-18_x
    nodePackages.pnpm
    curl
    wget
    pkg-config
    libiconv
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.WebKit
    darwin.apple_sdk.frameworks.Cocoa
  ];
  rust-packages =
    if isLinux then rust-packages-linux else rust-packages-darwin;
  rust-packages-with-my-packages = commonBuildInputs ++ rust-packages ++ [
    pkgs.rust-analyzer
    pkgs.rustfmt
    pkgs.cargo-tauri
    pkgs.trunk
    pkgs.wasm-bindgen-cli
    pkgs.wasm-pack
    pkgs.binaryen
    pkgs.protobuf
    rust-toolchain
    pkgs.nodePackages_latest.tailwindcss
  ] ++ rust-packages ++ localBuildInputs;

  R-with-my-packages = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [ ggplot2 dplyr xts ];
  };

  python = [
    (pkgs.python3.withPackages
      (ps: [ ps.matplotlib ps.numpy ps.pandas ps.scipy ]))

    pkgs.curl
    pkgs.jq
  ] ++ localBuildInputs;

  nextjs = [ pkgs.nodejs_20 pkgs.nodePackages.npm ];

  cloudflare_workers =
    [ pkgs.nodejs_20 pkgs.nodePackages.npm pkgs.nodePackages.wrangler ];
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
    buildInputs = commonBuildInputs ++ [ pkgs.ffmpeg-full ];
    shellHook = commonShellHook;
  };
  latex = pkgs.mkShell {
    buildInputs = commonBuildInputs ++ localBuildInputs
      ++ [ pkgs.texlive.combined.scheme-full pkgs.inkscape pkgs.pandoc ];
    shellHook = commonShellHook;
  };
  # Also see https://www.tomhoule.com/2021/building-rust-wasm-with-nix-flakes/
  rust = pkgs.mkShell {
    buildInputs = rust-packages-with-my-packages;
    shellHook = commonShellHook;
  };
  R = pkgs.mkShell {
    buildInputs = commonBuildInputs
      ++ [ R-with-my-packages pkgs.pandoc pkgs.texlive.combined.scheme-full ];
    shellHook = commonShellHook;
  };
  python = pkgs.mkShell {
    buildInputs = commonBuildInputs ++ python;
    shellHook = commonShellHook;
  };
  nextjs = pkgs.mkShell {
    buildInputs = commonBuildInputs ++ nextjs;
    shellHook = commonShellHook;
  };
  cloudflare = pkgs.mkShell {
    buildInputs = commonBuildInputs ++ cloudflare_workers;
    shellHook = commonShellHook;
  };
  local = pkgs.mkShell {
    buildInputs = commonBuildInputs ++ localBuildInputs;
    shellHook = commonShellHook;
  };
})
