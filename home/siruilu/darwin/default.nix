{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../common {
        inherit isWSL;
        inherit inputs;

      }
    )
  ];
  home.packages = with pkgs; [
    iina
    raycast
  ];
  home.homeDirectory = "/Users/siruilu";
}
