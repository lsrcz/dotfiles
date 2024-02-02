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
  home.homeDirectory = "/Users/siruilu";
}
