{ config, pkgs, ... }:
let
     customVim = (import ./pkgs/vim.nix { inherit pkgs; });
in
{
  nixpkgs.config.allowUnfree = true;

  hardware.pulseaudio.enable = true; 

  networking.networkmanager.enable = true;

  i18n = {
    consoleKeyMap = "us";
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
      gnome3.networkmanagerapplet
      gnome3.gnome_terminal
      gnome3.adwaita-icon-theme

      # apps
      firefox-beta-bin
      thunderbird
      slack
      spotify
      evince
      arandr

      # dev stuff
      htop
      customVim
      libreoffice-fresh

      # programming
      git

      # misc
      lm_sensors
      openfortivpn
  ];

  fonts = {
    fontconfig = {
      enable = true;
    };
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
  programs.bash.shellAliases = {
      "vim" = "${customVim}/bin/vim";
  };
  services.dbus.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
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
        configFile = "/etc/i3config";
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
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };

  users.defaultUserShell = "/run/current-system/sw/bin/bash";
  users.extraUsers.stefan = {
     isNormalUser = true;
     uid = 1000;
     extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "systemd-journal" ];
  };

  environment.variables.EDITOR = "${customVim}/bin/vim";
  environment.etc."i3config".text = (import ./pkgs/i3.nix { inherit pkgs; });
  environment.etc."i3status.conf".text = import ./pkgs/i3status.nix;
}
