{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.devenv
    pkgs.direnv
    pkgs.fnm
    pkgs.gh
    pkgs.go
    pkgs.bun
    pkgs.biome
    pkgs.opencode
  ];
}
