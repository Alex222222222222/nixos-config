{ }: {
  # clean journalctl
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * journalctl --vacuum-time=7d --vacuum-size=128M 1>/dev/null"
    ];
  };

  # garbange collection check https://nixos.wiki/wiki/Nix_Cookbook#Reclaim_space_on_Nix_install.3F
  nix.gc.automatic = true;
  nix.settings.auto-optimise-store = true;
}
