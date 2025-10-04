{
  description = "Example nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
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
