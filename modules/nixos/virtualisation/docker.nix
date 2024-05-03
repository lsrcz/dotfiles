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
        virtualisation = {
          containers = {
            enable = true;
          };
          docker = {
            enable = true;
            rootless = {
              enable = true;
              setSocketVariable = true;
              daemon.settings = mkIf cfg.enableNvidia {
                runtimes = {
                  nvidia = {
                    path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
                  };
                };
              };
            };
            enableNvidia = cfg.enableNvidia;
          };
          oci-containers.backend = "docker";
        };
        hardware.nvidia-container-toolkit.enable = cfg.enableNvidia;
        hardware.opengl.driSupport32Bit =
          mkIf (pkgs.stdenv.isx86_64 && cfg.enableNvidia) true;
      };
}
