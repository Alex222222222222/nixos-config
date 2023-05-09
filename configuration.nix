# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Config Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zifan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };
  # user ssh authorized_keys
  users.users.zifan.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDbZqo2WJ5GeKWwFp9WaAeIIZh9DKNUvmF0bhB+nTiUPZCReuRY6CtxUl/C3j2cU6BxcVY1t4R41IvIwG5CLz9mnHJshv4I2F8y20NrBqZyL5n6DM5CRhzRXonZohdHP8eheTePajLI9z7PHdyD/OaVLch2nStpv7q343mbuK+9nknbRj77J53tDUPqoMaH/8QLtqPksEi8PLtBdaW0afTmikR24Jzt4bDTLPuTIvVvAqipjyGsH14AhuovYOjw35HFORAwA/nhNp2qjVVz04qFnt12B5ZEjGcDMItqWqOp5hdn0ukUQ8tEs9ScayDT9FnJPRtjRuQSa6GjlGn7+c/oR6xsdvKZ9uCApzMnpP04YjnCuF+rAJ9lhIKPvXLWB1g7viM4579umIM2BmU1njLz7Bgj2dATU2TGcpPMT5mpXp9vUmP3kP6+MUCI1pL1Q0fI+ilpmnT7kB5Lihf0vXOYBlLI1hvTAKiJY/A/xUdd5ZYtGvKxhZkF1rDB/Fnl268= zifanhua@Zifans-MacBook-Pro.local" # content of authorized_keys file
  ];
  home-manager.users.zifan = { pkgs, ... }: {
    home.packages = [
      pkgs.zsh
      pkgs.firefox

      pkgs.rust-analyzer
    ];
    home.stateVersion = "22.11";
    programs.bash.enable = true;

    systemd.user.sessionVariables = {
      EDITOR = "vim";
    };
    home.sessionVariables = {
      EDITOR = "emacs";
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
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Gnome, check https://nixos.wiki/wiki/GNOME
    gnomeExtensions.appindicator

    curl
    tmux
    ncdu
    htop
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git

    # clipboard sharing for qemu
    spice-vdagent
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.spice-vdagentd.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 23 ];
  networking.firewall.allowedUDPPorts = [ 22 23 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

