{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil # nix lsp - default
    nixd # nix lsp
    nixfmt-rfc-style # nix formatter
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "nixfmt";
        };
      }
    ];
    settings = {
      theme = "doom_acario_dark";
    };
  };
}
