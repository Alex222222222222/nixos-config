{ config, pkgs, ... }:

{
  home.username = "zifan";
  home.homeDirectory = "/home/zifan";

  home.packages = [
    pkgs.zsh
    pkgs.firefox

    # pkgs.rust-analyzer
    
    pkgs.ncdu
    pkgs.htop
  ];
  home.stateVersion = "22.11";
  programs.bash.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
 
  systemd.user.sessionVariables = {
    EDITOR = "vim";
  };
  home.sessionVariables = {
    EDITOR = "vim";
  };

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
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    extraConfig = "
  ${builtins.readFile ./neovim/init.vim}
    ";
    extraLuaConfig = "
  ${builtins.readFile ./neovim/init.lua}
    ";
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      vim-nix
      lualine-nvim
      wildfire-vim
    ];
    coc = {
      enable = true;
      settings = {
        "diagnostic.virtualTextCurrentLineOnly" = true;
        "rust-analyzer.check.command" = "clippy";
        "rust-analyzer.check.features" = "all";
        "tailwindCSS.includeLanguages" = {
          "eelixir" = "html";
          "elixir" = "html";
          "eruby" = "html";
          "html.twig" = "html";
          "javascript" = "javascriptreact";
          "rs" = "html";
          "rust" = "html";
        };
        "markdownlint.config" = {
          "MD013" = {
            "code_block_line_length" = 120;
          };
          "code_block_line_length" = 120;
        };
        "cSpell.language" = "en-GB";
  };
    };
  };
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    initExtra = "
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      source ~/.p10k.zsh

      # check https://github.com/marlonrichert/zsh-autocomplete
      bindkey '\\t' menu-complete \"$terminfo[kcbt]\" reverse-menu-complete
      # bindkey '\\t' menu-select \"$terminfo[kcbt]\" menu-select
      # bindkey -M menuselect '\\t' menu-complete \"$terminfo[kcbt]\" reverse-menu-complete
      # all Tab widgets
      zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
      # all history widgets
      zstyle ':autocomplete:*history*:*' insert-unambiguous yes
      # ^S
      zstyle ':autocomplete:menu-search:*' insert-unambiguous yes
      # bindkey -M menu-select '\\r' .accept-line
      zstyle ':autocomplete:*' min-delay 0.10  # seconds (float)
    ";
    shellAliases = {
      l = "ls -a";
      ll = "ls -l";
    };
    history = {
      size = 10000;
      path = "$HOME/zsh/history";
    };
    plugins = [
      {
        name = "zsh-autocomplete";
    file = "zsh-autocomplete.plugin.zsh";
    src = pkgs.fetchgit {
      url = "https://github.com/marlonrichert/zsh-autocomplete.git";
      rev = "eee8bbeb717e44dc6337a799ae60eda02d371b73";
      fetchSubmodules = true;
      hash = "sha256-2qkB8I3GXeg+mH8l12N6dnKtdnaxTeLf5lUHWxA2rNg=";
    };
      }
    ];
    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
  home.file.".p10k.zsh".source = ./p10k.zsh;
}

