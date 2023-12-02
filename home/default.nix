{ config, pkgs, lib, ... }: 
let
  user = "shepard";
  xdg_configHome = "/home/${user}/.config";
in
{
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    file = import ./files { inherit user; };
    packages = with pkgs; [
      alacritty
      bat
      btop
      htop
      git

      rofi
      rofi-calc
      
      feh # for wallpaper

      chromium

      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.2.2";
            sha256 = "8f038cfba2e71f20a4be13935524d466f831efb8c083a845082a41a98f00c488";
          }
        ];
      })
    ];

    stateVersion = "24.05";
  };

  services.polybar = {
    enable = true;
    config = pkgs.substituteAll {
      src = ./config/polybar/config.ini;
    };
    script = "polybar main &";
  };

  #services.dunst = {
  #  enable = true;
  #  package = pkgs.dunst;
  #  settings = {
  #    global = {
  #      monitor = 0;
  #      follow = "mouse";
  #      border = 0;
  #      height = 400;
  #      width = 320;
  #      offset = "33x65";
  #      indicate_hidden = "yes";
  #      shrink = "no";
  #      separator_height = 0;
  #      padding = 32;
  #      horizontal_padding = 32;
  #      frame_width = 0;
  #      sort = "no";
  #      idle_threshold = 120;
  #      font = "Noto Sans";
  #      line_height = 4;
  #      markup = "full";
  #      format = "<b>%s</b>\n%b";
  #      alignment = "left";
  #      transparency = 10;
  #      show_age_threshold = 60;
  #      word_wrap = "yes";
  #      ignore_newline = "no";
  #      stack_duplicates = false;
  #      hide_duplicate_count = "yes";
  #      show_indicators = "no";
  #      icon_position = "left";
  #      icon_theme = "Adwaita-dark";
  #      sticky_history = "yes";
  #      history_length = 20;
  #      history = "ctrl+grave";
  #      browser = "google-chrome-stable";
  #      always_run_script = true;
  #      title = "Dunst";
  #      class = "Dunst";
  #      max_icon_size = 64;
  #    };
  #  };
  #};

  programs.git = {
    userName = "Alex Troshkin";
    userEmail = "alextroshkin@outlook.com";
  };  
}
