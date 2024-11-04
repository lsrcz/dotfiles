{ isWSL, sshKeyPath, inputs, ... }:
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
    htop
    hyperfine
    siruilu.stack-upload
    siruilu.stack-upload-doc
  ];
  programs.home-manager.enable = true;
  programs.ssh.enable = true;
  programs.tmux.enable = true;
  siruilu.shell.zsh.useDefault = true;

  programs.git = {
    enable = true;
    userEmail = "siruilu@cs.washington.edu";
    userName = "Sirui Lu";
    delta.enable = true;
    signing.signByDefault = true;
    signing.key = null;
  };

  programs.ssh.matchBlocks = {
    nixos = {
      identityFile = sshKeyPath;
      port = 28093;
      hostname = "172.234.236.43";
      user = "siruilu";
    };
    linode = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "172.234.236.43";
      user = "siruilu";
    };
    ptc = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "ptc.cs.washington.edu";
      user = "siruilu";
    };
    recycle = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "recycle.cs.washington.edu";
      user = "siruilu";
    };
    bicycle = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "bicycle.cs.washington.edu";
      user = "siruilu";
    };
    tricycle = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "tricycle.cs.washington.edu";
      user = "siruilu";
    };
    ptc-jump = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "ptc.cs.washington.edu";
      user = "siruilu";
      proxyJump = "recycle";
    };
    bananapi-local = {
      identityFile = sshKeyPath;
      port = 22;
      hostname = "192.168.0.63";
      user = "siruilu";
    };
    bananapi = {
      identityFile = sshKeyPath;
      port = 28095;
      hostname = "172.234.236.43";
      user = "siruilu";
    };
  };
}
