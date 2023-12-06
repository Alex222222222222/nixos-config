{ inputs, config, pkgs, system-stateVersion, system, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # i18n
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users.users.zifan = {
    isNormalUser = true;
    description = "Zifan Hua";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    ncdu
    tmux
    htop
    bandwhich
  ];

  # Disable suspend on close laptop lib
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # clean journalctl
  services.cron = {
    enable = true;
    systemCronJobs = [ "0 0 * * * journalctl --vacuum-time=7d 1>/dev/null" ];
  };

  # garbange collection check https://nixos.wiki/wiki/Nix_Cookbook#Reclaim_space_on_Nix_install.3F
  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;

  system.stateVersion = system-stateVersion;
}
