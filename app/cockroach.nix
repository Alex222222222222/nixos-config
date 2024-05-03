{ config, pkgs, ... }: {
  # config for cockroachdb
  services.cockroachdb =
    {
      enable = true;
      # open the port for the cockroachdb service
      openPorts = true;
      # listen to localhost for intra-cluster communication
      listen.address = "localhost";
      # join the cluster
      join = "chicago.tail0c3f1.ts.net:26257,euserv.tail0c3f1.ts.net:26257,server-factory-us.tail0c3f1.ts.net:26257,haruka.tail0c3f1.ts.net:26257";
      # certs for the cluster
      certsDir = "/var/lib/cockroach/certs";
      # insecure = true;
    };

  users.groups.cockroachdb = { };
  users.users.cockroachdb = {
    group = "cockroachdb";
    isSystemUser = true;
  };
}
