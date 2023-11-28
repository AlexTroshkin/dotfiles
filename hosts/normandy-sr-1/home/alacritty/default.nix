{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.alacritty ];
}
