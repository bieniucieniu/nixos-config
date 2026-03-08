{ pkgs, self, ... }:
{
  environment.systemPackages = [
    pkgs.cocoapods
    pkgs.mpv
    pkgs.watch
  ];
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
