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
  programs.ssh.extraConfig = ''
    Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
}
