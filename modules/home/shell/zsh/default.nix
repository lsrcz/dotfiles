{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.siruilu.shell.zsh;
in
{
  options = {
    siruilu.shell.zsh.useDefault =
      mkEnableOption (mdDoc "Use the default zsh configuration");
  };
  config = mkIf cfg.useDefault {
    programs.zsh.enable = true;
    programs.zsh.antidote.enable = true;
    programs.zsh.antidote.plugins = [
      "zsh-users/zsh-autosuggestions"
      "romkatv/powerlevel10k kind:fpath"
    ];
    programs.zsh.initExtra = ''
      [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      autoload -Uz promptinit && promptinit && prompt powerlevel10k
    '';
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
