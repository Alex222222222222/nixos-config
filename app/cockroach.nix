{ ... }: {
  services.cockroachdb = {
    enable = true;
    cache = "1GB";
    certsDir = /etc/cockroachdb/certs;
    extraArgs = [
      "--advertise-addr"
      "*"
      # "--num-expected-initial-nodes"
      # "5"
      "--init-token"
      "secret"
    ];
    http = {
      address = "*";
      port = 8081;
    };
    join =
      "macbookair.alex1222.com:26257,racknerd.alex1222.com:26257,chicago.alex1222.com:26257,server-factory.alex1222.com:26257";
    listen = {
      address = "*";
      port = 26257;
    };
    maxSqlMemory = "1GB";
  };

  environment.etc."cockroachdb/certs/README.md" = {
    enable = true;
    group = "cockroachdb";
    user = "cockroachdb";
    text = ''
      # This directory is used to store certificates for CockroachDB.
      # The certificates are generated automatically by NixOps.
      # You can replace them with your own certificates if you want to.
    '';
  };

  # one time setup
  /* systemd.services.cockroachdb_setup = {
       description = "CockroachDB setup";
       wantedBy = [ "multi-user.target" ];
       serviceConfig = {
         Type = "oneshot";
         User = "cockraochdb";
         Group = "cockroachdb";
       };

       script = ''
         mkdir -p /etc/cockroachdb/certs
       '';
     };
  */

  networking.firewall.allowedTCPPorts = [ 26257 ];
  networking.firewall.allowedUDPPorts = [ 26257 ];
}
