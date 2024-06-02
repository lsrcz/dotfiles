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
    bicycle = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "bicycle.cs.washington.edu";
      user = "siruilu";
    };
    linode = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "172.234.236.43";
      user = "siruilu";
    };
    ptc = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "ptc.cs.washington.edu";
      user = "siruilu";
      proxyJump = "tricycle";
    };
    bananapi = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "192.168.0.63";
      user = "siruilu";
    };
  };
}
