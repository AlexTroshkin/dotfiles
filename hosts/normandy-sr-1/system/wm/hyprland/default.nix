{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true; 
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;      
      extraPortals = [ 
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  environment = {
    variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      WLR_NO_HARDWARE_CURSORS = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = [
      pkgs.xdg-utils
      pkgs.libva-utils
    ];
  };
}
