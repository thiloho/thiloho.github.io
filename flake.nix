{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixd
              nixfmt
            ];
          };
        }
      );

      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          evalServerScript = pkgs.writeShellApplication {
            name = "eval-server";
            runtimeInputs = [ pkgs.nix ];
            text = ''
              set -euo pipefail

              echo "▶ Evaluating NixOS configuration for '.#server'..."
              nix eval .#nixosConfigurations.server.config.system.build.toplevel > /dev/null
              echo "✅ Evaluation succeeded — configuration is valid."
            '';
          };

          deployServerScript = pkgs.writeShellApplication {
            name = "deploy-server";
            runtimeInputs = with pkgs; [
              nix
              openssh
            ];
            text = ''
              set -euo pipefail

              "${evalServerScript}/bin/eval-server"

              nix run nixpkgs#nixos-rebuild-ng -- \
                --flake .#server \
                --target-host thohlt@91.98.171.83 \
                --sudo \
                --ask-sudo-password \
                switch
            '';
          };
        in
        {
          eval-server = {
            type = "app";
            program = "${evalServerScript}/bin/eval-server";
          };

          deploy-server = {
            type = "app";
            program = "${deployServerScript}/bin/deploy-server";
          };
        }
      );

      nixosConfigurations =
        let
          mkSystem =
            entrypoint:
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit inputs; };
              modules = [
                entrypoint
                { nix.registry.nixpkgs.flake = nixpkgs; }
              ];
            };
        in
        {
          server = mkSystem ./server;
        };
    };
}
