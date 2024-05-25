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
      hostname = "172.234.236.43";
      user = "siruilu";
    };
    linode = {
      identityFile = "/Users/siruilu/.ssh/id_ed25519";
      port = 22;
      hostname = "172.234.236.43";
      user = "siruilu";
    };
    ptc = {
      identityFile = "/Users/siruilu/.ssh/id_ed25519";
      port = 22;
      hostname = "ptc.cs.washington.edu";
      user = "siruilu";
    };
    recycle = {
      identityFile = "/Users/siruilu/.ssh/id_ed25519";
      port = 22;
      hostname = "recycle.cs.washington.edu";
      user = "siruilu";
    };
    ptc-jump = {
      identityFile = "/Users/siruilu/.ssh/id_ed25519";
      port = 22;
      hostname = "ptc.cs.washington.edu";
      user = "siruilu";
      proxyJump = "recycle";
    };
  };
  programs.ssh.extraConfig = ''
    Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
}
