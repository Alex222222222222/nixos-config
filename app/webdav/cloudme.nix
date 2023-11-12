{config, pkgs, ...}:
{
  services.davfs2.enable = true;
  services.autofs = {
    enable = true;
    autoMaster = "/mnt/ /etc/davfs2/cloudme.auto.mount";
  };
  environment.etc."davfs2/cloudme.auto.mount" = {
    text = ''
      cloudme -fstype=davfs,conf=/etc/davfs2/cloudme.conf,rw https\://webdav.cloudme.com/eawufyhaew
    '';
    mode = "0440";
  };
  environment.etc."davfs2/cloudme.conf" = {
    text = ''
      secrets ${config.age.secrets.cloudme-webdav-secrets.path}
    '';
    mode = "0440";
  };
}

