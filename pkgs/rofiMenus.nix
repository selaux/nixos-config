{ pkgs ? import <nixpkgs> {} }:
let
    inherit (pkgs) stdenv makeWrapper writeScript rofi rofi-menugen;
    evaluateCurrentDpi = "$(${pkgs.xorg.xrdb}/bin/xrdb -query | grep dpi | sed 's/Xft.dpi:\s//g')";
    rofi-with-dpi = stdenv.mkDerivation {
      name = "rofi-with-dpi-${rofi.version}";
      src = ./.;
      buildInputs = [ rofi makeWrapper ];
      installPhase = ''
        mkdir -p $out/bin
        makeWrapper ${rofi}/bin/rofi $out/bin/rofi --add-flags '-dpi ${evaluateCurrentDpi}'
      '';
    };
    rofi-menugen-with-dpi = rofi-menugen.override { rofi = rofi-with-dpi; };

    powerManagement = writeScript "rofi-power-management" ''
        #!${rofi-menugen-with-dpi}/bin/rofi-menugen
        #begin main
        back=false
        prompt="Select:"
        add_exec 'Lock'         '${pkgs.i3lock-fancy}/bin/i3lock-fancy'
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
