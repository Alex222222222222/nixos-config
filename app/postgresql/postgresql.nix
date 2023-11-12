{config, pkgs, ...}:
{
  services.postgresql = {
    settings = {
      listen_addresses = "*";
    };
    enable = true;
    ensureDatabases = [ "freshrss" ];
    enableTCPIP = true;
    port = 5332;
    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
      # freshrss
      host freshrss freshrss 0.0.0.0/0 scram-sha-256
    '';
    initialScript = "/etc/postgresql/initial_script";
  };

  system.activationScripts."postgresql_database_secret" = ''
    secret=$(cat "${config.age.secrets.postgresql-freshrss-pass.path}")
    configFile=/etc/postgresql/initial_script
    ${pkgs.gnused}/bin/sed -i "s#@{{ FRESH_RSS_PASS }}@#$secret#" "$configFile"
  '';

  environment.etc = {
    # Creates /etc/nanorc
    "postgresql/initial_script" = {
      text = ''
        CREATE ROLE freshrss WITH LOGIN PASSWORD '{{ FRESH_RSS_PASS }}' CREATEDB;
        CREATE DATABASE freshrss;
        GRANT ALL PRIVILEGES ON DATABASE freshrss TO freshrss;
      '';

      # The UNIX file mode bits
      mode = "0440";
    };
  };
}