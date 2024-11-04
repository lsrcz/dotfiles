{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../nixos {
        inherit isWSL;
        inherit inputs;
        sshKeyPath = "/home/siruilu/.ssh/id_ed25519_keyless";
      }
    )
  ];
}
