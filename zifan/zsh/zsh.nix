{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    initExtra = "
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
      
      ${builtins.readFile ./p10k.zsh}

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
}
