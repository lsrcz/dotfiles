{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    (
      import ../darwin {
        inherit isWSL;
        inherit inputs;
        sshKeyPath = "/Users/siruilu/.ssh/id_ed25519";
      }
    )
  ];
  programs.ssh.extraConfig = ''
    Host *
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  '';
}

