{ ... }:

{
  services = {      
    getty.autologinUser = "shepard";

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];

      layout = "us";
      xkbVariant = "";

      # Comment this for AMD GPU
      # This helps fix tearing of windows for Nvidia cards
      screenSection = ''
        Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option       "AllowIndirectGLXProtocol" "off"
        Option       "TripleBuffer" "on"
      '';

      # Select display manager
      displayManager = {
        defaultSession = "none+bspwm";
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
        };
      };

      # Select tiling window manager
      windowManager = {
        bspwm.enable = true;
      };    
    };

    autorandr = {
      enable = true;
      profiles = {
        "default" = {
          fingerprint = {
            DP-0 = "00ffffffffffff0061a94634000000000d1f0104b55021783b64f5ad5049a322135054adcf00714f81c0814081809500a9c0b300d1c0226870a0d0a02950302035001d4e3100001a20fd70a0d0a03c50302035001d4e3100001e000000fd003090a0a03c010a202020202020000000fc004d69204d6f6e69746f720a202002ac020327f44c010203040590111213141f3f23090707830100006d1a00000201309000000000000020ac00a0a0382d40302035001d4e3100001ef0d270a0d0a03c50302035001d4e3100001ea348b86861a03250304035001d4e3100001ef57c70a0d0a02950302035001d4e3100001e00000000000000000000000000000000b27012790000030014bf2f01046f0d9f002f001f009f053b000280040007000a0881000804000402100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e190";
          };
          config = {
            DP-0 = {
              enable = true;
              primary = true;
              mode = "3440x1440";
              rate = "144.00";
            };
          };
        };
      };
    };

    picom = {
      enable = true;
      settings = {
        animations = true;
        animation-stiffness = 300.0;
        animation-dampening = 35.0;
        animation-clamping = false;
        animation-mass = 1;
        animation-for-workspace-switch-in = "auto";
        animation-for-workspace-switch-out = "auto";
        animation-for-open-window = "slide-down";
        animation-for-menu-window = "none";
        animation-for-transient-window = "slide-down";
        corner-radius = 12;
        rounded-corners-exclude = [
          "class_i = 'polybar'"
          "class_g = 'i3lock'"
        ];
        round-borders = 3;
        round-borders-exclude = [];
        round-borders-rule = [];
        shadow = true;
        shadow-radius = 8;
        shadow-opacity = 0.4;
        shadow-offset-x = -8;
        shadow-offset-y = -8;
        fading = false;
        inactive-opacity = 0.8;
        frame-opacity = 0.7;
        inactive-opacity-override = false;
        active-opacity = 1.0;
        focus-exclude = [
        ];

        opacity-rule = [
          "100:class_g = 'i3lock'"
          "60:class_g = 'Dunst'"
          "100:class_g = 'Alacritty' && focused"
          "90:class_g = 'Alacritty' && !focused"
        ];

        blur = {
          method = "dual_kawase";
          strength = 8;
          background = false;
          background-frame = false;
          background-fixed = false;
        };

        shadow-exclude = [
          "class_g = 'Dunst'"
        ];

        blur-background-exclude = [
          "class_g = 'Dunst'"
        ];

        backend = "glx";
        vsync = false;
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = false;
        detect-transient = true;
        detect-client-leader = true;
        use-damage = true;
        log-level = "info";

        wintypes = {
          normal = { fade = true; shadow = false; };
          tooltip = { fade = true; shadow = false; opacity = 0.75; focus = true; full-shadow = false; };
          dock = { shadow = false; };
          dnd = { shadow = false; };
          popup_menu = { opacity = 1.0; };
          dropdown_menu = { opacity = 1.0; };
        };
      };
    };
  };
}