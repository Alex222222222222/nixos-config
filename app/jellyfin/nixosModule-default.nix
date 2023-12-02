{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  options = {
    services.jellyfin = {
      enable = mkEnableOption (lib.mdDoc "Jellyfin Media Server");

      user = mkOption {
        type = types.str;
        default = "jellyfin";
        description = lib.mdDoc "User account under which Jellyfin runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.jellyfin;
        defaultText = literalExpression "pkgs.jellyfin";
        description = lib.mdDoc ''
          Jellyfin package to use.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = lib.mdDoc "Group under which jellyfin runs.";
      };

    };
  };

  config = mkIf cfg.enable {
    systemd.services.jellyfin = {
      description = "Jellyfin Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # This is mostly follows: https://github.com/jellyfin/jellyfin/blob/master/fedora/jellyfin.service
      # Upstream also disable some hardenings when running in LXC, we do the same with the isContainer option
      serviceConfig = rec {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "jellyfin";
        StateDirectoryMode = "0700";
        CacheDirectory = "jellyfin";
        CacheDirectoryMode = "0700";
        UMask = "0077";
        WorkingDirectory = "/var/lib/jellyfin";
        ExecStart = "${cfg.package}/bin/jellyfin --datadir '/var/lib/${StateDirectory}' --cachedir '/var/cache/${CacheDirectory}'";
        Restart = "on-failure";
        TimeoutSec = 15;
        SuccessExitStatus = [ "0" "143" ];

        # Security options:
        NoNewPrivileges = true;
        SystemCallArchitectures = "native";
        # AF_NETLINK needed because Jellyfin monitors the network connection
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" ];
        RestrictNamespaces = !config.boot.isContainer;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectControlGroups = !config.boot.isContainer;
        ProtectHostname = true;
        ProtectKernelLogs = !config.boot.isContainer;
        ProtectKernelModules = !config.boot.isContainer;
        ProtectKernelTunables = !config.boot.isContainer;
        LockPersonality = true;
        PrivateTmp = !config.boot.isContainer;
        # needed for hardware acceleration
        PrivateDevices = false;
        PrivateUsers = true;
        RemoveIPC = true;

        SystemCallFilter = [
          "~@clock"
          "~@aio"
          "~@chown"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
        SystemCallErrorNumber = "EPERM";
      };
    };

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = { };
    };

  };

  meta.maintainers = with lib.maintainers; [ minijackson ];
}
