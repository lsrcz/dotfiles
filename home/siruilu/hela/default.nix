{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../darwin {
        inherit isWSL;
        inherit inputs;
      }
    )
  ];

  programs.ssh.matchBlocks = {
    nixos = {
      identityFile = "/Users/siruilu/.ssh/id_ed25519";
      port = 28093;
      hostname = "tricycle.cs.washington.edu";
      user = "siruilu";
    };
  };
}
