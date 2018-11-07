{ pkgs ? import <nixpkgs> {}, theme ? import ../theme/base16Tomorrow.nix }:
let
    inherit (theme.colors.normal) foreground background gray red blue black;
    inherit (pkgs) stdenv makeWrapper writeScript rofi rofi-menugen;
    evaluateCurrentDpi = "$(${pkgs.xorg.xrdb}/bin/xrdb -query | grep dpi | sed 's/Xft.dpi:\s//g')";
    themeFile = pkgs.writeText "rofiTheme" ''
        * {
            selected-normal-foreground:  @lightbg;
            foreground:                  #${foreground};
            normal-foreground:           @foreground;
            alternate-normal-background: @lightbg;
            red:                         #${red};
            selected-urgent-foreground:  @background;
            blue:                        #${blue};
            urgent-foreground:           @red;
            alternate-urgent-background: @lightbg;
            active-foreground:           @blue;
            lightbg:                     #${background};
            selected-active-foreground:  @background;
            alternate-active-background: @lightbg;
            background:                  #${background};
            alternate-normal-foreground: @foreground;
            normal-background:           @background;
            lightfg:                     #${foreground};
            selected-normal-background:  @blue;
            border-color:                @foreground;
            spacing:                     2;
            separatorcolor:              @foreground;
            urgent-background:           @background;
            selected-urgent-background:  @red;
            alternate-urgent-foreground: @red;
            background-color:            #${black};
            alternate-active-foreground: @blue;
            active-background:           @background;
            selected-active-background:  @blue;
        }
        #window {
            background-color: @background;
            border:           1;
            padding:          5;
        }
        #mainbox {
            border:  0;
            padding: 0;
        }
        #message {
            border:       1px dash 0px 0px ;
            border-color: @separatorcolor;
            padding:      1px ;
        }
        #textbox {
            text-color: @foreground;
        }
        #listview {
            fixed-height: 0;
            border:       2px dash 0px 0px ;
            border-color: @separatorcolor;
            spacing:      2px ;
            scrollbar:    false;
            padding:      2px 0px 0px ;
        }
        #element {
            border:  0;
            padding: 1px ;
        }
        #element.normal.normal {
            background-color: @normal-background;
            text-color:       @normal-foreground;
        }
        #element.normal.urgent {
            background-color: @urgent-background;
            text-color:       @urgent-foreground;
        }
        #element.normal.active {
            background-color: @active-background;
            text-color:       @active-foreground;
        }
        #element.selected.normal {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        #element.selected.urgent {
            background-color: @selected-urgent-background;
            text-color:       @selected-urgent-foreground;
        }
        #element.selected.active {
            background-color: @selected-active-background;
            text-color:       @selected-active-foreground;
        }
        #element.alternate.normal {
            background-color: @alternate-normal-background;
            text-color:       @alternate-normal-foreground;
        }
        #element.alternate.urgent {
            background-color: @alternate-urgent-background;
            text-color:       @alternate-urgent-foreground;
        }
        #element.alternate.active {
            background-color: @alternate-active-background;
            text-color:       @alternate-active-foreground;
        }
        #sidebar {
            border:       2px dash 0px 0px ;
            border-color: @separatorcolor;
        }
        #button {
            spacing:    0;
            text-color: @normal-foreground;
        }
        #button.selected {
            background-color: @selected-normal-background;
            text-color:       @selected-normal-foreground;
        }
        #inputbar {
            spacing:    0;
            text-color: @normal-foreground;
            padding:    1px ;
        }
        #case-indicator {
            spacing:    0;
            text-color: @normal-foreground;
        }
        #entry {
            spacing:    0;
            text-color: @normal-foreground;
        }
        #prompt {
            spacing:    0;
            text-color: @normal-foreground;
        }
    '';
    rofi-with-dpi = stdenv.mkDerivation {
      name = "rofi-with-dpi";
      src = ./.;
      buildInputs = [ rofi makeWrapper ];
      installPhase = ''
        mkdir -p $out/bin
        makeWrapper ${rofi}/bin/rofi $out/bin/rofi --add-flags '-dpi ${evaluateCurrentDpi} -theme ${themeFile}'
      '';
    };
    rofi-menugen-with-dpi = rofi-menugen.override { rofi = rofi-with-dpi; };

    lockScript = writeScript "i3lock-fancy-dunst" ''
        # suspend message display
        ${pkgs.procps}/bin/pkill -u "$USER" -USR1 dunst

        # lock the screen
        ${pkgs.i3lock-fancy}/bin/i3lock-fancy -n -p

        # resume message display
        ${pkgs.procps}/bin/pkill -u "$USER" -USR2 dunst
    '';

    powerManagement = writeScript "rofi-power-management" ''
        #!${rofi-menugen-with-dpi}/bin/rofi-menugen
        #begin main
        back=false
        prompt="Select:"
        add_exec 'Lock'         '${lockScript}'
        add_exec 'Reboot'       'systemctl reboot'
        add_exec 'Power Off'     'systemctl poweroff'
        #end main
    '';
in
stdenv.mkDerivation {
    name = "custom-rofi-menus";
    srcs = ./.;
    buildInputs = [ makeWrapper ];
    installPhase = ''
        makeWrapper ${rofi-with-dpi}/bin/rofi $out/bin/application-menu --add-flags '-show drun'
        makeWrapper ${powerManagement} $out/bin/power-menu --add-flags '-dpi ${evaluateCurrentDpi}'
    '';
}
