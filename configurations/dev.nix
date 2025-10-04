{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.devenv
    pkgs.fnm
    pkgs.gh
    pkgs.go
  ];
}
