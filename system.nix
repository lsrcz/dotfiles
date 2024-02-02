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
  userHomeManagerConfig = ./home/${username}/${hostname};
  buildSystem = if isDarwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
  siruilu = import ./lib { inherit (nixpkgs) lib; };
  commonModules = [
    ({ pkgs, ... }:
      {
        nixpkgs.overlays = [
          (import ./pkgs { inherit siruilu; })
        ];
      })
    hostConfig
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
  nixosOnlyModules = [ ];
  darwinModules = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "siruilu";
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
        };
        mutableTaps = false;
      };
    }
  ];
in
buildSystem rec {
  inherit system;
  modules = commonModules ++
    (if isDarwin then darwinModules else nixosOnlyModules);
}
