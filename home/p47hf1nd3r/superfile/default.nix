{ pkgs, ... }:

{
  home.packages = with pkgs; [
    superfile
  ];

  home.file.".config/superfile/config.toml".source = ./config.toml;
}
