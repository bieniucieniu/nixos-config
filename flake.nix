{
  description = "Example nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/v2.0.2";
    # nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    # nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      # nixos-wsl,
    }:
    let
      sharedConfiguration = ./configurations/shared.nix;
      devConfiguration = ./configurations/dev.nix;
      macConfiguration =
        { pkgs, ... }:
        import ./configurations/mac.nix {

          inherit self pkgs;
        };
      nixosConfiguration = ./configurations/nixos.nix;
      # wslConfiguration = ./configurations/wsl.nix;
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hardware/thinkpad-configuration.nix
          sharedConfiguration
          nixosConfiguration
        ];
      };
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # nixos-wsl.nixosModules.default
          #        ./hardware/wsl-configuration.nix
          # wslConfiguration
          sharedConfiguration
        ];
      };

      darwinConfigurations."Mikolajs-Mac-mini" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin"; # As specified in your mac config
        modules = [
          home-manager.darwinModules.home-manager
          devConfiguration
          sharedConfiguration
          macConfiguration
        ];
      };

      # Global Nix configuration settings, apply to both systems
      nixConfig = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        allow-unfree = true;
      };
    };
}
