{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "mikolajbien"; # Set your username

  # boot.loader.grub.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?

}
