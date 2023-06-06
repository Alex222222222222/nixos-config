{ config, pkgs, system-stateVersion, ... }:

{
  imports = [
    ./git.nix { inherit pkgs; }
    ./neovim/neovim.nix { inherit pkgs; }
    ./zsh/zsh.nix { inherit pkgs; }
  ];

  home.username = "zifan";
  home.homeDirectory = "/home/zifan";

  home.packages = [
    pkgs.zsh
    pkgs.neovim
    pkgs.wget
    pkgs.curl
    pkgs.ncdu
    pkgs.htop
  ];

  home.stateVersion = system-stateVersion;
  programs.bash.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

