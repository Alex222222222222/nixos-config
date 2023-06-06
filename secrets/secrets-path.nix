{config, inputs, ...}:
{
  imports = [
    inputs.agenix.nixosModules.age
  ];

  age.secrets = {
    hetzner-webdav-secrets = {
      file = ./hetzner-webdav-secrets;
      owner = "root";
      group = "root";
      mode = "600";
      path = "/etc/davfs2/secrets";
    };
  };
}
