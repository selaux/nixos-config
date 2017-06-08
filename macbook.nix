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

  boot.loader.grub.device = "/dev/disk/by-id/usb-APPLE_SD_Card_Reader_000000000820-0:0";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "cryptroot";
      device = "/dev/disk/by-uuid/b6645c30-a63b-42c1-9af0-ef98de3b209b";
      preLVM = true;
    }
  ];

  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/disk/by-uuid/b6645c30-a63b-42c1-9af0-ef98de3b209b
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd-hda-intel model=mbp101
    options hid_apple fnmode=2
  '';

  hardware.facetimehd.enable = true;

  services.xserver.displayManager.xserverArgs = [ "-dpi 192" ];
  environment.variables.GDK_SCALE = "2"; 

  services.dockerRegistry.enable = true;
}
