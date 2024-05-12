# Inspired by
# https://www.auntieneo.net/2014/12/14/reverse-ssh-tunnel-on-nixos-with-systemd/
{ config, lib, pkgs, ... }:

with lib;

let
  inherit (pkgs) autossh;
  cfg = config.services.ssh-phone-home;
in

{

  ###### interface

  options = {
    services.ssh-phone-home = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable a "phone home" reverse SSH proxy.
        '';
      };

      persist = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When this is set to true, the service will persistently attempt to
          reconnect at intervals whenever the port forwarding operation fails.
          This is the recommended behavior for reliable operation. If one finds
          oneself in an environment where this kind of behavior might draw the
          suspicion of a network administrator, it might be a good idea to
          set this option to false (or not use <literal>ssh-phone-home</literal>
          at all).
        '';
      };

      localUser = mkOption {
        description = ''
          Local user to connect as (i.e. the user with password-less SSH keys).
        '';
      };

      localPort = mkOption {
        description = ''
          Local port to be forwarded.
        '';
      };

      remoteHostname = mkOption {
        description = ''
          The remote host to connect to. This should be the host outside of the
          firewall or NAT.
        '';
      };

      remotePort = mkOption {
        default = 22;
        description = ''
          The port on which to connect to the remote host via SSH protocol.
        '';
      };

      remoteUser = mkOption {
        description = ''
          The username to connect to the remote host as.
        '';
      };

      bindPort = mkOption {
        default = 2222;
        description = ''
          The port to bind and listen to on the remote host.
        '';
      };
      
      autosshMonitoringPort = mkOption {
        default = 20000;
        description = ''
          The port for autossh to monitor on.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.ssh-phone-home =
      {
        description = ''
          Reverse SSH tunnel as a service
        '';

        # FIXME: This isn't triggered until a reboot, and probably won't work between suspends.
        wantedBy = [ "multi-user.target" ];

        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];

        serviceConfig = with cfg; {
          User = cfg.localUser;
        } // (if cfg.persist then
          {
            # Restart every 10 seconds on failure
            RestartSec = 10;
            Restart = "on-failure";
          }
        else { }
        );

        script = with cfg;  ''
          ${autossh}/bin/autossh -M ${toString autosshMonitoringPort} -NTC -R ${toString bindPort}:localhost:${toString localPort} -l ${remoteUser} -p ${toString remotePort} ${remoteHostname}
        '';
      };
  };
}
