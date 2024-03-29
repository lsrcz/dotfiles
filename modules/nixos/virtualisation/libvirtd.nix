{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.siruilu.virtualisation.libvirtd;
in
{
  options.siruilu.virtualisation.libvirtd.useDefault =
    mkEnableOption (mdDoc "Use default libvirtd configuration.");
  config = mkIf cfg.useDefault
    {
      boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
          swtpm.enable = true;
          runAsRoot = false;
        };
        onBoot = "ignore";
        onShutdown = "shutdown";
      };

      environment.etc = {
        "ovmf/edk2-x86_64-secure-code.fd" = {
          source = config.virtualisation.libvirtd.qemu.package +
            "/share/qemu/edk2-x86_64-secure-code.fd";
        };
        "ovmf/edk2-x86_64-code.fd" = {
          source = config.virtualisation.libvirtd.qemu.package +
            "/share/qemu/edk2-x86_64-code.fd";
        };
        "ovmf/edk2-i386-vars.fd" = {
          source = config.virtualisation.libvirtd.qemu.package +
            "/share/qemu/edk2-i386-vars.fd";
        };
      };
      boot.extraModprobeConfig = ''
        options kvm ignore_msrs=1
      '';
    };
}
