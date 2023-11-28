inputs @ { home-manager, ... }:

let
  home-module = { ... }: {
    imports = [
      ./git/default.nix
      ./hyprland/default.nix
      ./hyprpaper/default.nix
      ./alacritty/default.nix
      ./helix/default.nix
      ./browsers/default.nix
    ];

    home = {
      username = "shepard";
      homeDirectory = "/home/shepard";
      stateVersion = "23.11";
    };

    programs.home-manager.enable = true;
  };
in

home-manager.nixosModules.home-manager {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = inputs;
  home-manager.users.shepard = home-module;
}
