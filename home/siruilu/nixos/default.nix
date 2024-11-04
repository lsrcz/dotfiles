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
  home.homeDirectory = "/home/siruilu";
  services.vscode-server.enable = true;
}
