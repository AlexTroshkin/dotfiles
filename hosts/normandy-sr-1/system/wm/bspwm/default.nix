{ pkgs, ... }:

{
  services.xserver.windowManager.bspwm = {
    enable = true;
  };
}
