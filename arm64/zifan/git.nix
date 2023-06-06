{
  # check https://jeppesen.io/git-commit-sign-nix-home-manager-ssh/
  programs.git = {
    enable = true;
    userName = "Zifan Hua";
    userEmail = "zifan.hua@icloud.com";

    extraConfig = {
      core.editor = "nvim"; 
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_rsa.pub";
    };
  };
}
