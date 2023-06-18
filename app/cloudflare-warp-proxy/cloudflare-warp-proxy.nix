{inuputs, port, ...}:
{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    cloudflare-warp-proxy = {
      image = "yarmak/warp-proxy";
      autoStart = true;
      ports = [ "127.0.0.1:39999:40000" ];
      extraOptions = [
      ];
    };
  };
}
