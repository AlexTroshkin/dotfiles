{ ... }:

{
  imports = [
    #./hyprland
    #./hyprpaper
    ./helix
    ./git
    ./wm/bspwm
  ];

  home = {
    username = "shepard";
    homeDirectory = "/home/shepard";
    stateVersion = "24.05";
  };
   
  programs.home-manager.enable = true;
}
