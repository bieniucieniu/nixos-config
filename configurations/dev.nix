{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.devenv
    pkgs.fnm
    pkgs.gh
    pkgs.go
    pkgs.bun
    pkgs.biome
  ];
}
