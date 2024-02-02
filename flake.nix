{
  description = "Sirui's NixOS Configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      siruilu = import ./lib { inherit (nixpkgs) lib; };
      mkSystem = import ./system.nix { inherit nixpkgs; inherit inputs; };
    in
    {
      nixosConfigurations = {
        zeus = mkSystem "zeus" {
          system = "x86_64-linux";
          username = "siruilu";
        };
      };
    };
}
