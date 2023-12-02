{ ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b692797b-be54-4ff0-87d6-cb981170f34f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/AE13-372F";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
