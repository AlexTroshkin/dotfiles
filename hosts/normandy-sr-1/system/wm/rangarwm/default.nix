{ pkgs, ... }:

{
  services.xserver.windowManager.ragnarwm = {
    enable = true;
    package = (pkgs.ragnarwm.override {
      conf = ./config.h;
    });
  };
}
