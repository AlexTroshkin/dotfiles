{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./gpu
    #./picom
    #./wm/ragnarwm
    #./wm/hyprland
    ./wm/bspwm
    ./git
    ./alacritty
    ./browsers
    ./helix
    ./vscode
    ./telegram
    ./obsidian
  ];
}
