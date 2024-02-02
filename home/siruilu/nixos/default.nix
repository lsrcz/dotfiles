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
  home.homeDirectory = "/home/siruilu";
  services.vscode-server.enable = true;
}
