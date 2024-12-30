{ username, pkgs, ... }:

{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";
  };

  imports = [
    ./alacritty
    ./firefox
    ./helix
    ./hyprland
    ./keepassxc
    ./mattermost
    ./openconnect
    ./obsidian
  ];

  # Just pakcages without configs
  home.packages = with pkgs; [
    just # https://github.com/casey/just
  ];

  programs = {
    # Let Home Manager install and manage itself
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Alex Troshkin";
      userEmail = "alextroshkin@outlook.com";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
