let
  nixos-racknerd-zifan =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3WZzDoWCJ3pfjDR3BPbmMmanIk0tNbup5U/F0vtfNE zifan@racknerd";
  m1-macbook =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local";
  nixos-server-factory-zifan =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMEbWF5tOP9ul4s/rAfx615yEb0z9yjEtiX254rFcdS/ zifan@nixos";
  nixos-chicago-zifan =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHc4St5vGhGAAAtwT3o0vXrS+yQUazihqGDX9rUnJ55m zifan@chicago";
  nixos-macbookair-zifan =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIMPRbG0ogui/sRecGgAjOvd5bLFqyX/rSh7I/vbOCYs zifan@nixos";
  users = [
    nixos-racknerd-zifan
    m1-macbook
    nixos-server-factory-zifan
    nixos-chicago-zifan
    nixos-macbookair-zifan
  ];

  nixos-racknerd-system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxPhGZ9rAx1bTm5kJ/l4a2CGk4iGY29278KJy7RQLlX root@racknerd";
  nixos-server-facotry-system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaMHTBU+qGcs13MqOC/J0rE0e0NzmatWhy1R2AyNgoI root@nixos";
  nixos-chicago-system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINczAuiza3yv/OUfP42BtdDuAAjb2qe6nbJ8pXihT7nG root@chicago";
  nixos-macbookair-system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcb0+jSQ8yeKKq8xdwkf+nJ58g4IDZbSCPeF9MlqvVe root@nixos";
  systems = [
    nixos-racknerd-system
    nixos-server-facotry-system
    nixos-chicago-system
    nixos-macbookair-system
  ];

  all = systems ++ users;
in
{
  "hetzner-webdav-secrets".publicKeys = all;
  "cloudflare-email-api-key".publicKeys = all;
  "v2ray-config".publicKeys = all;
  "hysteria-obfs".publicKeys = all;
  "hysteria-alpn".publicKeys = all;
  "tailscale-key".publicKeys = all;
  "postgresql-freshrss-pass".publicKeys = all;
  "cloudme-webdav-secrets".publicKeys = all;
  "freshrss_tunnel_token".publicKeys = all;
  "k3s-common-secret".publicKeys = all;
  "k3s-tailscale".publicKeys = all;
  "pass-3proxy".publicKeys = all;
  "scylla_proxy_tunnel_token".publicKeys = all;
  "scylla_webui_tunnel_token".publicKeys = all;
}
