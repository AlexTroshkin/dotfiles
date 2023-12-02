{ lib, ... }:

{
  networking = {
    hostName = "normandy-sr-1"; 
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
}