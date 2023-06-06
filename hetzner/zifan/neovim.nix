{pkgs,...}:

{
  # set default editor to vim
  systemd.user.sessionVariables = {
    EDITOR = "vim";
  };
  home.sessionVariables = {
    EDITOR = "vim";
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
}
