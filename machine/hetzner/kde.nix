{ inputs, config, pkgs, system-stateVersion, system, ... }:
{
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        gwenview
        okular
        oxygen
        khelpcenter
        konsole
        plasma-browser-integration
        print-manager
        spectacle
        kwalletmanager
    ];

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = true;

    environment.systemPackages = with pkgs; [
        firefox
        vlc
    ];
}