{
  description = "Yet another Nix OS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
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
        specialArgs = {
          username = "p47hf1nd3r";
          inputs = inputs;
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/normandy-sr-1
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
