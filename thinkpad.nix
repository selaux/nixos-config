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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.luks.devices = [
    {
      name = "lvm";
      device = "/dev/sda3";
      preLVM = true;
    }
  ];
  
  services.thinkfan = {
    enable = true;
    sensors = "hwmon /sys/class/hwmon/hwmon2/temp1_input";
  };
}
