# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, currentSystemHostname, ... }:


{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../nixos
      ../../modules/nixos
    ];

  # Bootloader.
  boot.loader = {
    timeout = 5;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      timeoutStyle = "menu";
      fsIdentifier = "label";
      # useOSProber = true;
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod chain
          search --set=root --label WINDOWSEFI
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
        menuentry "Fedora" {
          insmod part_gpt
          insmod btrfs
          insmod ext2
          search --set=root --label FEDORABOOT
          configfile /grub2/grub.cfg
        }
      '';
    };
  };

  networking.hostName = currentSystemHostname; # Define your hostname.
  # networking.enableIPv6 = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.siruilu = {
    isNormalUser = true;
    description = "Sirui Lu";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAaj1WYe9Ja/0lMbiQpXZDbZhy0udIyFUkJQgiKru20E9DFKEWpSoUMIqHvTxyc2ZxtNo/8W0rBnBIGEsRW5Fek= iPadFaceID"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4s0E0IMdYIIphhv9K/tB67aLLKMVAyge/5ZpyR9qXN zeus"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUUSlXy5VmEZw80NFH8AxiU2H0rfCWqImI+vrxzEd/r"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAoHpRgSTp2ANmSeY7vAGikhotyQDb1lcKzYknuo373Z"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqDHWA5lV/kbnUA40SiY9FjuqJl8kUKe3DfAy8FJlyQ hera"
    ];
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    samba
    htop
    cifs-utils
    gnupg
    smartmontools
    direnv
    cachix
    pciutils
    sysstat
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 86400;
      max-cache-ttl = 86400;
    };
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Default shell
  # users.users.siruilu.shell = pkgs.zsh;
  # environment.shells = with pkgs; [ zsh ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable X11 forwarding.
  services.openssh.settings.X11Forwarding = true;

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  services.openssh.ports = [ 1898 ];
  services.openssh.openFirewall = true;

  services.ssh-phone-home = {
    enable = true;
    persist = true;
    localUser = "siruilu";
    localPort = 1898;
    remoteHostname = "linode";
    remotePort = 22;
    remoteUser = "siruilu";
    bindPort = 8094;
    autosshMonitoringPort = 20000;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Enable VSCode Server
  # services.vscode-server.enable = true;

  # Enable experimental features for nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable mcelog
  hardware.mcelog.enable = true;

  nix.settings.trusted-users = [ "root" "siruilu" ];

  # Fwupd
  services.fwupd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # nvidia
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
    nvidiaPersistenced = true;
  };
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    extraConfig = ''
      min protocol = SMB2
      use sendfile = yes
      log level = 1 auth:5 winbind:5 auth_audit:3 auth_json_audit:3
    '';
    shares = {
      backup = {
        path = "/mnt/hdd";
        "valid users" = "siruilu";
        public = "no";
        writeable = "yes";
        "force user" = "siruilu";
      };
      time = {
        path = "/mnt/hdd/Time Machine";
        "valid users" = "siruilu";
        public = "no";
        writeable = "yes";
        "force user" = "siruilu";
        "vfs objects" = "acl_xattr catia fruit streams_xattr";
        "fruit:advertise_fullsync" = "true";
        "fruit:metadata" = "stream";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "aio read size" = "1";
        "aio write size" = "1";
        "spotlight" = "yes";
      };
    };
  };

  networking.firewall.interfaces."virbr0" = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };
  networking.firewall.interfaces."eno2" = {
    allowedTCPPorts = [ 139 445 ];
    allowedUDPPorts = [ 137 138 ];
  };

  siruilu.virtualisation.libvirtd.useDefault = true;
  siruilu.virtualisation.docker.useDefault = true;
  siruilu.virtualisation.docker.enableNvidia = true;

  services.resolved.enable = true;

  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];

  services.code-server = {
    enable = true;
    auth = "none";
    port = 20808;
    host = "127.0.0.1";
    user = "siruilu";
    disableTelemetry = true;
  };

  siruilu.virtualisation.nvidia-passthrough = {
    enable = true;
    blocked-gpus = [ "RTX4090" ];
  };

  boot.binfmt.emulatedSystems = [ "riscv32-linux" "riscv64-linux" ];
}
