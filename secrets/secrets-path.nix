{config, inputs, system, ...}:
{
  imports = [
  ];

  environment.systemPackages = [
    inputs.agenix.packages.${system}.default
  ];

  age.secrets = {
    hetzner-webdav-secrets = {
      file = ./hetzner-webdav-secrets;
      owner = "root";
      group = "root";
      mode = "600";
    };
    cloudflare-email-api-key = {
      file = ./cloudflare-email-api-key;
      owner = "root";
      group = "root";
      mode = "600";
    };
    v2ray-config = {
      file = ./v2ray-config;
      owner = "root";
      group = "root";
      mode = "600";
    };
  };
}
