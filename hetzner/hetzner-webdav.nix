{config, pkgs, ...}:
{
  services.davfs2.enable = true;
  services.autofs = {
    enable = true;
    autoMaster = "/mnt/ /etc/davfs2/auto.mount";
  };
  environment.etc."davfs2/auto.mount" = {
    text = ''
      hetzner -fstype=davfs,conf=/etc/davfs2/conf,rw https\://u323536.your-storagebox.de
    '';
    mode = "0440";
  };
  environment.etc."davfs2/conf" = {
    text = ''
      secrets /etc/davfs2/secrets
    '';
    mode = "0440";
  };
}

