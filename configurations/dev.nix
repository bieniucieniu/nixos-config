{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.devenv.overrideAttrs (prev: rec {
      version = "2.0.3";
      src = pkgs.fetchFromGitHub {
        inherit (prev.src) owner repo;
        tag = "v2.0.3";
        hash = "sha256-1DpF5F7zgOZ7QrRjz23315pUoF532dHnsU/V4UQithk=";
      };
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-gZFRbTDPQNKf2msBv9wOavaH1iB1Tk3shYf0/4TSZBQ=";
      };
    }))

    pkgs.direnv
    pkgs.fnm
    pkgs.gh
    pkgs.go
    pkgs.bun
    pkgs.biome
    pkgs.opencode
  ];
}
