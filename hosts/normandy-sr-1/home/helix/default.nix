{ pkgs, ... }:

{ 
  home.file.".config/helix" = {
    source = ./config;
    recursive = true;
  };
}
