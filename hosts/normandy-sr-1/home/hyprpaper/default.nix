{ pkgs, ... }:

{ 
  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };

  environment.systemPackages = [
    pkgs.hyprpaper
  ];
}
