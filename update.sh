#!/bin/sh

nix flake update
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     sudo nixos-rebuild switch --flake .#$(hostname);;
    Darwin*)    darwin-rebuild switch --flake .#$(hostname);;
    *)          echo "Unknown system ${unameOut}" && exit -1;; 
esac

