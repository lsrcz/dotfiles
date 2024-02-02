{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.siruilu.virtualisation.nvidia-passthrough;
  deviceId = {
    "RTX4090" = [ "10de:2684" "10de:226a" ];
  };
in
{
  options = {
    siruilu.virtualisation.nvidia-passthrough = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Nvidia passthrough";
      };

      blocked-gpus = mkOption {
        type = with types; listOf (enum [ "RTX4090" ]);
        default = [ ];
        description = "List of blocked GPUs";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = lib.mkBefore [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    boot.kernelParams = [
      "intel_iommu=on"
    ] ++ (if cfg.blocked-gpus != [ ]
    then [
      ("vfio-pci.ids=" +
        lib.concatStringsSep ","
          (concatMap (device: deviceId.${device}) cfg.blocked-gpus))
    ]
    else
      [ ]);
    hardware.opengl.enable = true;
  };
}
