{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../nixos {
        inherit isWSL;
        inherit inputs;
      }
    )
  ];
  programs.ssh.matchBlocks = {
    tricycle = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "tricycle.cs.washington.edu";
      user = "siruilu";
    };
  };
}
