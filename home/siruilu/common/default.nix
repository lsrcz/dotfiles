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
  siruilu.shell.zsh.useDefault = true;
}
