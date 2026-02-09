#!/usr/bin/env nix-shell
#!nix-shell -i bash -p home-manager

# Build and activate the Home Manager configuration
home-manager build --flake ~/nixos-config#mikolajbien
home-manager switch --flake ~/nixos-config#mikolajbien