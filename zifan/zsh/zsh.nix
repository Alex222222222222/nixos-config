{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    initExtra =
      "\n      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true\n      \n      ${
              builtins.readFile ./p10k.zsh
            }\n\n      # check https://github.com/marlonrichert/zsh-autocomplete\n      bindkey '\\t' menu-complete \"$terminfo[kcbt]\" reverse-menu-complete\n      # bindkey '\\t' menu-select \"$terminfo[kcbt]\" menu-select\n      # bindkey -M menuselect '\\t' menu-complete \"$terminfo[kcbt]\" reverse-menu-complete\n      # all Tab widgets\n      zstyle ':autocomplete:*complete*:*' insert-unambiguous yes\n      # all history widgets\n      zstyle ':autocomplete:*history*:*' insert-unambiguous yes\n      # ^S\n      zstyle ':autocomplete:menu-search:*' insert-unambiguous yes\n      # bindkey -M menu-select '\\r' .accept-line\n      zstyle ':autocomplete:*' min-delay 0.10  # seconds (float)\n    ";
    shellAliases = {
      l = "ls -a";
      ll = "ls -l";
    };
    history = {
      size = 10000;
      path = "$HOME/zsh/history";
    };
    plugins = [{
      name = "zsh-autocomplete";
      file = "zsh-autocomplete.plugin.zsh";
      src = pkgs.fetchgit {
        url = "https://github.com/marlonrichert/zsh-autocomplete.git";
        rev = "eee8bbeb717e44dc6337a799ae60eda02d371b73";
        fetchSubmodules = true;
        hash = "sha256-2qkB8I3GXeg+mH8l12N6dnKtdnaxTeLf5lUHWxA2rNg=";
      };
    }];
    zplug = {
      enable = true;
      plugins = [{
        name = "romkatv/powerlevel10k";
        tags = [ "as:theme" "depth:1" ];
      } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
}
