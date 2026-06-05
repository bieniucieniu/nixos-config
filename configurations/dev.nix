{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.devenv
    pkgs.direnv
    pkgs.fnm
    pkgs.gh
    pkgs.go
    pkgs.bun
    pkgs.biome
    # pkgs.gemini-cli
    pkgs.tree-sitter
    pkgs.nil
    pkgs.openapi-generator-cli
    pkgs.sqlc
    pkgs.kubectl
    pkgs.fluxcd
  ];
}
