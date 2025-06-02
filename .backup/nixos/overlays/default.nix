{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.alacritty-theme.overlays.default
  ];
}
