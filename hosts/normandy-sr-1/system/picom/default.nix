{ pkgs, ... }:

{
  environment.systemPackages = [ 
    pkgs.picom-next
  ];
}