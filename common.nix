{ config, pkgs, stdenv, ... }:
let
    theme = import ./theme/base16Tomorrow.nix;
    rofiMenus = import ./pkgs/rofiMenus.nix { inherit pkgs theme; };
    alacritty = import ./pkgs/alacritty.nix { inherit pkgs theme; };
    customVim = import ./pkgs/vim.nix { inherit pkgs; };
    evolutionEws = import ./pkgs/evolutionEws.nix pkgs;
in
{
  imports = [
    ./modules/x-umlauts.nix
  ];

  boot.plymouth.enable = true;
  boot.extraModulePackages = [ pkgs.linuxPackages.wireguard ];

  services.tlp.enable = true;

  system.stateVersion = "18.03";

  nix.useSandbox = false;
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
      i3status
      pythonPackages.py3status
      iw
      acpi

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
      libreoffice
      slack
      hexchat
      gnome3.evince
      gnome3.eog
      arandr
      zoom-us

      # dev stuff
      htop
      customVim
      vscode
      nodejs
      rustup
      gcc
      sbt

      # programming
      git
      alacritty

      # gaming
      steam
      wine
      ja2-stracciatella

      # misc
      lm_sensors
      openfortivpn
      tree
      file
      curl
      ripgrep
      python3
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

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
  services.compton = {
    enable = true;
    vSync = "opengl-swc";
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
  environment.etc."i3config".text = (import ./pkgs/i3.nix { inherit pkgs alacritty rofiMenus theme; });
  environment.etc."i3status.conf".text = import ./pkgs/i3status.nix { inherit pkgs theme; };
  environment.etc."xdg/dunstrc".text = (import ./pkgs/dunstrc.nix { inherit pkgs theme; });

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
}
