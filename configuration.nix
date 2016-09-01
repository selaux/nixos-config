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
      i3status
      dmenu
      firefox
      spotify
      lm_sensors
      leiningen
      git
      playerctl
      i3lock-fancy
      compton
      oh-my-zsh
      xfce.terminal
      xfce.xfce4volumed
      xfce.xfce4_power_manager
      (
          with import <nixpkgs> {};

          vim_configurable.customize {
              name = "vim";
              vimrcConfig.customRC = ''
                  syntax enable
                  set number
                  set backspace=indent,eol,start
                  
                  let g:ctrlp_map = '<c-p>'
                  let g:ctrlp_cmd = 'CtrlP'
                  let g:ctrlp_working_path_mode = 'ra'
                  let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

                  set smartindent
              '';
              vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
              vimrcConfig.vam.pluginDictionaries = [
                  { names = [
                      "vim-nix" 
                      # "Syntastic"
                      "The_NERD_tree"
                      "ctrlp"
                      # "rust-vim"
                      # "youcompleteme"
                      "vim-colorschemes"
                  ]; }
              ];
          }
    )
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
