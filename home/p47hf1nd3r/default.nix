{ username, ... }:

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
  ];

  services = {
    ssh-agent = {
      enable = true;
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
}
