{ config, pkgs, system-stateVersion, ... }:

{
  imports = [
    ./git.nix
    ./neovim/neovim.nix
    ./zsh/zsh.nix
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

