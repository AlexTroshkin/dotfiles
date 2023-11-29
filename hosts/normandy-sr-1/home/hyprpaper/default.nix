{ pkgs, ... }:

{ 
  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };

  home.packages = [
    pkgs.hyprpaper
  ];
}
