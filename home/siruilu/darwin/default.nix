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
  home.packages = with pkgs; [];
  home.homeDirectory = "/Users/siruilu";
}
