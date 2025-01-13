{ username, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./firefox
    ./helix
    ./hyprland
    ./hyprpaper
    ./keepassxc
    ./mako
    ./mattermost
    ./openconnect
    ./obsidian
    ./rider
    ./mattermost
    ./superfile
    ./udiskie
    ./uwsm
    ./zen-browser
  ];

  # Hack for udiskie and other tools that require tray unit
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  programs = {
    # Let Home Manager install and manage itself
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Alex Troshkin";
      userEmail = "alextroshkin@outlook.com";
    };
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

    file.".config/wallpapers/9c031d6a-7193-45be-8db0-003c5ec817a2.jpeg".source =
      ./../../wallpapers/9c031d6a-7193-45be-8db0-003c5ec817a2.jpeg;

    file.".config/wallpapers/8ad7f03f-e803-466b-b012-a26523893ecc.jpeg".source =
      ./../../wallpapers/8ad7f03f-e803-466b-b012-a26523893ecc.jpeg;

    # Just pakcages without configs
    packages = with pkgs; [
      btop
      blueman
      clipse
      just
      ulauncher
      telegram-desktop
      nekoray
      warp-terminal
    ];

    pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };
}
