{ isWSL, inputs, ... }:
{ config, pkgs, ... }:
{
  imports = [
    ../../../modules/home
  ];
  home.username = "siruilu";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    nixpkgs-fmt
    nodePackages.gitmoji-cli
    rnix-lsp
    siruilu.stack-upload
    siruilu.stack-upload-doc
  ];
  programs.home-manager.enable = true;
  programs.ssh.enable = true;
  programs.tmux.enable = true;
  programs.ssh.matchBlocks = {
    tricycle = {
      identityFile = "/home/siruilu/.ssh/id_ed25519_keyless";
      port = 22;
      hostname = "tricycle.cs.washington.edu";
      user = "siruilu";
    };
  };

  siruilu.shell.zsh.useDefault = true;
}
