{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.git
    pkgs.bottom
    pkgs.bash
    pkgs.fzf
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
}
