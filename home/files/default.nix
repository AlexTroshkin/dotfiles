{ user, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_stateHome  = "${home}/.local/state"; in
{
  "${xdg_configHome}/wallpapers" = {
      source = ./wallpapers;
      recursive = true;
  };

  "${xdg_configHome}/bspwm/bspwmrc" = {
    executable = true;
    text = ''
      #! /bin/sh
      
      # Set the number of workspaces
      bspc monitor -d 1 2 3 4 5 6

      # Window configurations
      bspc config border_width         0
      bspc config window_gap           8
      bspc config split_ratio          0.52
      bspc config borderless_monocle   true
      bspc config gapless_monocle      true

      # Padding outside of the window
      bspc config top_padding            36
      bspc config bottom_padding         0
      bspc config left_padding           0
      bspc config right_padding          0

      # Move floating windows
      bspc config pointer_action1 move

      # Resize floating windows
      bspc config pointer_action2 resize_side
      bspc config pointer_action2 resize_corner

      # Set properly monitor configuraton
      autorandr default

      sleep .25

      # Set background and top bar
      feh --bg-scale $HOME/.config/wallpapers/mountain.jpg

      sleep .25

      # Run polybar
      polybar &
    '';
  };

  "${xdg_configHome}/sxhkd/sxhkdrc" = {
    text = ''
    # Close window
    alt + F4
        bspc node --close

    # Make split ratios equal
    super + equal
          bspc node @/ --equalize

    # Make split ratios balanced
    super + minus
          bspc node @/ --balance

    # Toogle tiling of window
    super + d
          bspc query --nodes -n focused.tiled && state=floating || state=tiled; \
          bspc node --state \~$state

    # Toggle fullscreen of window
    super + f
          bspc node --state \~fullscreen

    # Swap the current node and the biggest window
    super + g
          bspc node -s biggest.window

    # Swap the current node and the smallest window
    super + shift + g
          bspc node -s biggest.window

    # Alternate between the tiled and monocle layout
    super + m
          bspc desktop -l next

    # Move between windows in monocle layout
    super + {_, alt + }m
          bspc node -f {next, prev}.local.!hidden.window

    # Focus the node in the given direction
    super + {_,shift + }{h,j,k,l}
          bspc node -{f,s} {west,south,north,east}

    # Focus left/right occupied desktop
    super + {Left,Right}
          bspc desktop --focus {prev,next}.occupied

    # Focus left/right occupied desktop
    super + {Up,Down}
          bspc desktop --focus {prev,next}.occupied

    # Focus left/right desktop
    ctrl + alt + {Left,Right}
         bspc desktop --focus {prev,next}

    # Focus left/right desktop
    ctrl + alt + {Up, Down}
         bspc desktop --focus {prev,next}

    # Focus the older or newer node in the focus history
    super + {o,i}
          bspc wm -h off; \
          bspc node {older,newer} -f; \
          bspc wm -h on

    # Focus or send to the given desktop
    super + {_,shift + }{1-9,0}
          bspc {desktop -f,node -d} '^{1-9,10}'

    # Preselect the direction
    super + alt + {h,j,k,l}
          bspc node -p {west,south,north,east}

    # Cancel the preselect
    # For context on syntax: https://github.com/baskerville/bspwm/issues/344
    super + alt + {_,shift + }Escape
          bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

    # Set the node flags
    super + ctrl + {m,x,s,p}
          bspc node -g {marked,locked,sticky,private}

    # Send the newest marked node to the newest preselected node
    super + y
          bspc node newest.marked.local -n newest.!automatic.local

    # Program launcher
    super + @space
          rofi -config -no-lazy-grab -show drun -modi drun -theme /home/${user}/.config/rofi/launcher.rasi

    # Terminal emulator
    super + Return
          alacritty

    # Jump to workspaces
    super + Tab
          bspc {node,desktop} -f last

    # Take a screenshot with PrintSc
    Print
         flameshot gui -c -p $HOME/.local/share/img/screenshots

    # Audio controls for + volume
    XF86AudioRaiseVolume
        pactl set-sink-volume @DEFAULT_SINK@ +5%

    # Audio controls for - volume
    XF86AudioLowerVolume
        pactl set-sink-volume @DEFAULT_SINK@ -5%

    # Audio controls for mute
    XF86AudioMute
        pactl set-sink-mute @DEFAULT_SINK@ toggle
    '';
  };
}
