{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./neovim.nix
    ./zsh.nix
  ];

  home.username = "zifan";
  home.homeDirectory = "/home/zifan";

  home.packages = [
    pkgs.zsh
    pkgs.firefox

    # pkgs.rust-analyzer
    
    pkgs.ncdu
    pkgs.htop
  ];

  # home.stateVersion = "23.05";
  programs.bash.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

