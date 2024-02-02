{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.siruilu.virtualisation.docker;
in
{
  options = {
    siruilu.virtualisation.docker = {
      useDefault =
        mkEnableOption (mdDoc "Use default docker configuration.");
      enableNvidia = mkEnableOption (mdDoc "Enable nvidia support.");
    };
  };
  config =
    mkIf
      cfg.useDefault
      {
        virtualisation.docker = {
          enable = true;
          rootless = {
            enable = true;
            setSocketVariable = true;
          };
          enableNvidia = cfg.enableNvidia;
        };
        hardware.opengl.driSupport32Bit =
          mkIf (pkgs.stdenv.isx86_64 && cfg.enableNvidia) true;
      };
}
