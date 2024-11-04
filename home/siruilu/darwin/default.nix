{ isWSL, sshKeyPath, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../common {
        inherit isWSL;
        inherit inputs;
        inherit sshKeyPath;
      }
    )
  ];
  home.packages = with pkgs; [];
  home.homeDirectory = "/Users/siruilu";
}
