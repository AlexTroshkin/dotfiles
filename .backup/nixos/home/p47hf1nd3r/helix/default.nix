{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    nil # nix lsp - default
    nixd # nix lsp
    nixfmt-rfc-style # nix formatter
    inputs.roslyn-language-server.packages.${pkgs.stdenv.hostPlatform.system}.roslyn-language-server
  ];

  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
    languages = {
      language-server.roslyn = {
        command = "roslyn-language-server";
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
        }
        {
          name = "c-sharp";
          language-servers = [ "roslyn" ];
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
