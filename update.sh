#!/bin/sh

nixos-rebuild switch --flake .#$(hostname)
