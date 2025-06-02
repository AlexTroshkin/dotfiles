{ config, username, ... }:

{
  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  home.file.".config/hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/${username}/hyprland/hyprland.conf";

  # Optional, hint Electron apps to use Wayland
  # home.sessionVariables.NIXOS_OZONE_WL = "1";
}
