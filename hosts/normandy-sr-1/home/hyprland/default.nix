{ ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./config/hyprland.conf;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true; 
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
  };
}
