{ inputs, config, pkgs, system-stateVersion, system, ... }:
{
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
        gnome-photos
        gnome-tour
        xterm
    ]) ++ (with pkgs.gnome; [
        ghex # hex editor
        tali # poker game
        totem # video player
        sushi # preview files in nautilus
        rygel # media server
        iagno # reversi game
        gedit # text editor
        geary # email client
        polari # irc client
        hitori # logic game
        gpaste # clipboard manager
        cheese # webcam
        atomix # logic game
        anjuta # ide
        vinagre # vnc client
        seahorse # password manager
        pomodoro # pomodoro timer

        gnome-music
        gnome-terminal
        epiphany # web browser
        evince # document viewer
        gnome-characters
        gnome-maps
        gnome-contacts
    ]);

    systemd.sockets.terminal-server = { 
        description = "Terminal Server Socket";
        wantedBy = [ "sockets.target" ];
        before = [ "multi-user.target" ];
        socketConfig.Accept = true;
        socketConfig.ListenStream = 5900;
    };

    networking.firewall.allowedTCPPorts = [ 5900 ];
    networking.firewall.allowedUDPPorts = [ 5900 ];

    systemd.services."terminal-server@" = {
        description = "Terminal Server";

        path = [
            pkgs.xorg.xorgserver.out
            pkgs.gawk
            pkgs.which
            pkgs.openssl
            pkgs.xorg.xauth
            pkgs.nettools
            pkgs.shadow
            pkgs.procps
            pkgs.util-linux
            pkgs.bash
        ];

        environment.FD_GEOM = "1024x786x24";
        environment.FD_XDMCP_IF = "127.0.0.1";
        #environment.FIND_DISPLAY_OUTPUT = "/tmp/foo"; # to debug the "find display" script

        serviceConfig = {
            StandardInput = "socket";
            StandardOutput = "socket";
            StandardError = "journal";
            ExecStart = "@${pkgs.x11vnc}/bin/x11vnc -rfbport 5900";
            # Don't kill the X server when the user quits the VNC
            # connection.  FIXME: the X server should run in a
            # separate systemd session.
            KillMode = "process";
        };
    };
}