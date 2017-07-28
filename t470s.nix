# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "lvm";
      device = "/dev/disk/by-uuid/76ea1fb5-f02b-4307-94c4-8c3ecf5b0c8c";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  services.xserver.displayManager.xserverArgs = [ "-dpi 192" ];
  fonts.fontconfig.dpi = 192;
}
