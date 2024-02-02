{ lib, ... }:
{
  overlays = import ./overlays.nix
    {
      inherit lib;
    };
}
