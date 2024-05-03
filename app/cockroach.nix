{ config, pkgs, ... }: {
  # config for cockroachdb
  services.cockroachdb =
    {
      enable = true;
      # open the port for the cockroachdb service
      openPorts = true;
      # listen to all interface for intra-cluster communication
      listen.address = "*";
      # join the cluster
      join = "chicago.tail0c3f1.ts.net:26257,euserv.tail0c3f1.ts.net:26257,server-factory-us.tail0c3f1.ts.net:26257,ihcat.tail0c3f1.ts.net:26257";
      # certs for the cluster
      certsDir = "/var/lib/cockroach/certs";
    };

  users.groups.cockroachdb = { };
  users.users.cockroachdb = {
    group = "cockroachdb";
    isSystemUser = true;
  };
}
