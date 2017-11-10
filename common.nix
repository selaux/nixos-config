{ config, pkgs, stdenv, ... }:
let
     customVim = (import ./pkgs/vim.nix { inherit pkgs; });
     evolutionEws = (import ./pkgs/evolutionEws.nix { inherit (pkgs) stdenv gnome3 libmspack wrapGAppsHook fetchurl cmake; });
in
{
  nix.package = pkgs.nixUnstable;
  nixpkgs.config.allowUnfree = true;

  hardware.pulseaudio = {
    enable = true;
    systemWide = true;
  };

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
      pavucontrol
      gnome3.networkmanagerapplet
      gnome3.adwaita-icon-theme
      gnome3.nautilus
      gnome3.nautilus-sendto
      gnome3.gnome_control_center
      gnome3.glib_networking
      gnome3.gnome-screenshot
      gnome3.file-roller

      # apps
      firefox-beta-bin
      chromium
      evolutionEws
      libreoffice-fresh
      slack
      spotify
      gnome3.evince
      gnome3.eog
      arandr

      # dev stuff
      htop
      customVim
      atom

      # programming
      git

      # misc
      lm_sensors
      openfortivpn
      tree
      wget
      file
      curl
      python3
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
      gnome-keyring.enable = true;
      gnome-terminal-server.enable = true;
      gnome-online-accounts.enable = true;
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  services.avahi.enable = true;

  users.defaultUserShell = "/run/current-system/sw/bin/bash";
  users.extraUsers.stefan = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "disk" "audio" "pulse" "video" "systemd-journal" "docker" "vboxusers" ];
   };

  services.dbus.packages = [ pkgs.gnome3.dconf evolutionEws ];
  systemd.packages = [ evolutionEws ];

  environment.variables.EDITOR = "${customVim}/bin/vim";
  environment.etc."i3config".text = (import ./pkgs/i3.nix { inherit pkgs; });
  environment.etc."i3status.conf".text = import ./pkgs/i3status.nix { inherit pkgs; };
  environment.etc."xdg/dunstrc".text = (import ./pkgs/dunstrc.nix { inherit pkgs; });

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
