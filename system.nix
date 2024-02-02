{ nixpkgs, inputs, }:

hostname:
{ system
, username
, isDarwin ? false
, isWSL ? false
}:

let
  os = if isDarwin then "darwin" else "nixos";
  hostConfig = ./hosts/${hostname};
  sharedOSConfig = ./hosts/${os};
  userHomeManagerConfig = ./home/${username}/${os};
  buildSystem = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
  siruilu = import ./lib { inherit (nixpkgs) lib; };
in
buildSystem rec {
  inherit system;
  modules = [
    ({ pkgs, ... }:
      {
        nixpkgs.overlays = [
          (import ./pkgs { inherit siruilu; })
        ];
      })
    hostConfig
    sharedOSConfig
    home-manager.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import userHomeManagerConfig {
        inherit isWSL;
        inherit inputs;
      };
    }
    {
      config._module.args = {
        currentSystem = system;
        currentSystemHostname = hostname;
        currentSystemUsername = username;
        isWSL = isWSL;
        inputs = inputs;
      };
    }
  ];
}
