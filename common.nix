{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware.pulseaudio.enable = true; 

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
      feh
      i3lock-fancy
      pa_applet
      gnome3.gnome_settings_daemon
      gnome3.networkmanagerapplet
      gnome3.gnome_terminal

      # apps
      firefox-beta-bin
      spotify
      arandr
      ( import ./pkgs/vim.nix )

      # programming
      git

      # misc
      lm_sensors
      openfortivpn
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

  programs.bash.enableCompletion = true;

  services.dbus.enable = true;
  services.xserver = {
    enable = true;
    layout = "de";
    displayManager = {
        slim.enable = true;
        slim.defaultUser = "stefan";
        slim.autoLogin = true;
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
  services.gnome3 = {
      gnome-terminal-server.enable = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/bash";
  users.extraUsers.stefan = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "systemd-journal" ];
  };

  environment.variables.EDITOR = "vim";
  environment.etc."i3status.conf".text = import ./pkgs/i3status.nix;
}
