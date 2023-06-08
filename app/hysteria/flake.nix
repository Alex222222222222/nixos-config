{
  description = "Hysteria Proxy";
  
  inputs = {
    # NixOS 官方软件源，这里使用 nixos-unstable 分支
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 self.lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          # The default package for 'nix build'. This makes sense if the
          # flake provides only one package or there is a clear "main"
          # package.
          default = pkgs.hysteria; 
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          # The default package for 'nix build'. This makes sense if the
          # flake provides only one package or there is a clear "main"
          # package.
          default = pkgs.mkShell {
            buildInputs = [ pkgs.socat ];
          };
           
        }
      );

      nixosModules.with-cloudflare-acme = {pkgs, system, config, ... }:           
      let
        types = pkgs.lib.types;
        mkOption = pkgs.lib.options.mkOption;
      in
      {
        options.services.hysteria = {
          enable = pkgs.lib.options.mkEnableOption "enable hysteria proxy service";
          port = mkOption {
            default = 36712;
            type = types.int;
          };
          protocol = mkOption {
            default = "wechat-video"; # "udp", "wechat-video", "faketcp". Empty = "udp"
            type = types.singleLineStr;
          };
          domain = mkOption {
            type = types.nonEmptyStr;
          };
          acme-cloudflare-secret = mkOption {
            type = types.path;
          };
          obfs =  mkOption {
            type = types.path;
          };
          alpn = mkOption {
            type = types.path;
          };
          acme-email = mkOption {
            default = "huazifan@gmail.com";
            type = types.singleLineStr;
          };
        };
        config = pkgs.lib.mkIf config.services.hysteria.enable {
          networking.firewall.allowedTCPPorts = [ config.services.hysteria.port ];
          networking.firewall.allowedUDPPorts = [ config.services.hysteria.port ];
          boot.kernel.sysctl."net.core.rmem_max" = 16777216;
          systemd.services.hysteria = {
            environment.LOGGING_LEVEL = "warn";
            serviceConfig = {
              User = "root";
              Group = "root";
              Restart = "always";
              ExecStart = "${pkgs.bash}/bin/bash /etc/hysteria/run.sh";
            };
          };
          security.acme = {
            acceptTerms = true;
            defaults.email = "${config.services.hysteria.acme-email}";
            certs."${config.services.hysteria.domain}" = {
              dnsProvider = "cloudflare";
              credentialsFile = config.services.hysteria.acme-cloudflare-secret;
            };
          };
          environment.etc."hysteria/run.sh" = {
            text = ''
              obfs=$(cat "${config.services.hysteria.obfs}")
              alpn=$(cat "${config.services.hysteria.alpn}")
              configFile=/etc/hysteria/config.json
              ${pkgs.gnused}/bin/sed -i "s#{{ obfs }}#$obfs#" "$configFile"
              ${pkgs.gnused}/bin/sed -i "s#{{ alpn }}#$alpn#" "$configFile"
              alpn=""
              obfs=""
              ${self.packages.${system}.default}/bin/hysteria -c /etc/hysteria/config.json server
            '';
            mode = "0440";
            user = "root";
            group = "root";
          };
          environment.etc."hysteria/config.json" = {
            text = ''
              {
                "listen": ":${toString config.services.hysteria.port}", 
                "protocol": "${config.services.hysteria.protocol}", 
                "cert": "/var/lib/acme/${config.services.hysteria.domain}/cert.pem", 
                "key": "/var/lib/acme/${config.services.hysteria.domain}/key.pem",
                "obfs": "{{ obfs }}", 
                "alpn": "{{ alpn }}", 
                "max_conn_client": 4096, 
                "resolver": "udp://1.1.1.1:53", 
              }
            '';
            mode = "0440";
            user = "root";
            group = "root";
          };
        };
      };
    };
}
