{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./gpu
    ./git
    ./alacritty
    ./browsers
    ./helix
    ./hyprland
    ./vscode
  ];
}