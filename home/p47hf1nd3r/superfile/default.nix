{ pkgs, ... }:

{
  home.packages = with pkgs; [
    superfile
  ];
}