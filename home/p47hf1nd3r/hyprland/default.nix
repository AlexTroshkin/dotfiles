{ ... }:

{
  # wayland.windowManager.hyprland = {
  #   enable = true;    
  # };

  home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

  # Optional, hint Electron apps to use Wayland
  # home.sessionVariables.NIXOS_OZONE_WL = "1";
}
