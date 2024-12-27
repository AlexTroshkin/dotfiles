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
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };
    settings = {
      theme = "doom_acario_dark";
      editor = {
        popup-border = "all";
        auto-format = true;

        lsp.display-messages = true;

        cursor-shape = {
          insert = "underline";
          select = "bar";
        };
        indent-guides = {
          render = true;
        };
      };
    };
  };
}
