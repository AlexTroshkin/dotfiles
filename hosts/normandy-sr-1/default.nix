{ config, pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./../../modules/hyprland.nix
  ];
}
