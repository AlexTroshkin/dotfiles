{
  description = "Yet another Nix OS configuration";

  inputs = {
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    helix.url = "github:sofusa/helix-pull-diagnostics";
    roslyn-language-server.url = "github:sofusa/roslyn-language-server";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    zen-browser.url = "github:AlexTroshkin/zen-browser-flake";
    ayugram-desktop.url = "github:/ayugram-port/ayugram-desktop/release?submodules=1";
  };

  outputs =
    inputs@{
      self,
      home-manager,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.normandy-sr-1 = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit system;
          inherit inputs;

          username = "p47hf1nd3r";
        };
        modules = [
          ./hosts/normandy-sr-1
          ./overlays
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${specialArgs.username} = import ./home/${specialArgs.username};
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
