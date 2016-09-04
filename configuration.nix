# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.stateVersion = "16.03";

  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
    }
  ];
  networking.networkmanager.enable = true;

  i18n = {
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
      # Status Bar and Deps
      playerctl
      i3status
      pythonPackages.py3status
      iw
      acpi

      # i3 Stuffs
      dmenu
      i3lock-fancy
      compton
      xfce.xfce4volumed
      xfce.xfce4_power_manager
      xfce.terminal

      # apps
      firefox
      spotify
      ( import ./pkgs/vim.nix )

      # programming
      git
      leiningen
      nodejs-6_x

      # misc
      lm_sensors
      oh-my-zsh
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      dejavu_fonts
      freefont_ttf
      liberation_ttf
    ];
  };

  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    ZSH_THEME="robbyrussell"
    DISABLE_AUTO_UPDATE="true"

    plugins=(git systemd)

    source $ZSH/oh-my-zsh.sh
  '';

  services.dbus.enable = true;
  services.thinkfan = {
    enable = true;
    sensor = "/sys/class/hwmon/hwmon2/temp1_input";
  };
  services.xserver = {
    enable = true;
    layout = "de";
    displayManager = {
        slim.enable = true;
        slim.defaultUser = "stefan";
    };
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    windowManager.default = "i3";
    windowManager.i3 = {
        enable = true;
        configFile = ./pkgs/i3;
    };

    libinput = {
        enable = true;
        disableWhileTyping = true;
        tapping = false;
    };
  };

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  users.extraUsers.stefan = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "systemd-journal" ];
  };

  environment.variables.EDITOR = "vim";
}
