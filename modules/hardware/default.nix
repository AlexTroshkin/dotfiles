{ lib, config, pkgs, ... }:

{
  hardware = {
    cpu = {
      intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [
        pkgs.libva
      ];
    };

    nvidia = {
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
  };
}
