{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.devenv
    # pkgs.direnv
    pkgs.fnm
    pkgs.gh
    pkgs.go
    pkgs.bun
    pkgs.biome
    pkgs.claude-code
    pkgs.tree-sitter
    pkgs.nil
  ];
}
