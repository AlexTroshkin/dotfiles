{ config, pkgs, ... }:

{
  # Add manually fbdev kernel parameter
  # for fix low resolution in tty
  boot = {
    kernelParams = [ "nvidia-drm.fbdev=1" ];
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [
      pkgs.libva
    ];
  };

  # Load nvidia driver for Xorg and Wayland (?)
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable nvidia
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    powerManagement = {
      enable = false;
      finegrained = false;
    };

    # Use the Nvidia open source kernel module
    open = true;

    # Enable the Nvidia settings menu
    # accessible via `nvidia-settings`
    nvidiaSettings = true;

    # Select driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
