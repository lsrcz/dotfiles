{ pkgs, config, ... }:
{
  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "05:45" ];
}
