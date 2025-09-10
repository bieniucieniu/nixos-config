{
  description = "Example nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      sharedConfiguration =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            pkgs.bottom
            pkgs.vim
            pkgs.bash
            pkgs.devenv
            pkgs.fzf
            pkgs.fnm
            pkgs.gh
            pkgs.lazygit
            pkgs.neovim
            pkgs.ripgrep
            pkgs.tmux
            pkgs.zoxide
            pkgs.zig
            pkgs.nixfmt-rfc-style
          ];

          nix.settings.experimental-features = "nix-command flakes";
          programs.fish.enable = true;
          users.users.mikolajbien.shell = pkgs.fish;
        };
      macConfiguration =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            pkgs.cocoapods
            pkgs.go
          ];
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 6;
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
      nixosConfiguration =
        { config, pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.kernelPackages = pkgs.linuxPackages_latest;

          networking.hostName = "nixos";
          networking.networkmanager.enable = true;

          time.timeZone = "Europe/Warsaw";

          i18n.defaultLocale = "en_US.UTF-8";
          i18n.extraLocaleSettings = {
            LC_ADDRESS = "pl_PL.UTF-8";
            LC_IDENTIFICATION = "pl_PL.UTF-8";
            LC_MEASUREMENT = "pl_PL.UTF-8";
            LC_MONETARY = "pl_PL.UTF-8";
            LC_NAME = "pl_PL.UTF-8";
            LC_NUMERIC = "pl_PL.UTF-8";
            LC_PAPER = "pl_PL.UTF-8";
            LC_TELEPHONE = "pl_PL.UTF-8";
            LC_TIME = "pl_PL.UTF-8";
          };

          hardware.bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings = {
              General = {
                Experimental = true;
              };
            };
          };

          services.xserver.enable = true;
          services.displayManager.sddm.enable = true;
          services.desktopManager.plasma6.enable = true;

          services.xserver.xkb = {
            layout = "us";
            variant = "";
          };

          services.printing.enable = true;
          services.openssh.enable = true;
          services.avahi.enable = true;

          services.pulseaudio.enable = false;
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };
          programs.fish.enable = true;
          users.users.mikolajbien = {
            isNormalUser = true;
            description = "mikolajbien";
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
            packages = with pkgs; [
              kdePackages.kate
            ];
          };

          environment.systemPackages = with pkgs; [
            neovim
            git
            curl
            qbittorrent
            mpv
            google-chrome
            ghostty
          ];

          system.stateVersion = "23.11"; # Or update to "25.05" if you truly mean that channel
        };
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
