{ config, pkgs, ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    serverAddr = "https://100.88.201.130:6443";
    tokenFile = config.age.secrets.k3s-common-secret.path;
    extraFlags = "--vpn-auth-file=${config.age.secrets.k3s-tailscale.path}";
    environmentFile = pkgs.writeText "k3s.env" ''
      PATH=$PATH:${pkgs.tailscale}/bin
    '';
  };

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  networking.firewall.allowedUDPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
}
