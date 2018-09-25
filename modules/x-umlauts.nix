{ config, pkgs, ... }:

let
  keymap = pkgs.writeText "keymap.xkb" ''
    xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)" };
        xkb_types     { include "complete"  };
        xkb_compat    { include "complete"  };
        xkb_symbols   { 
            include "pc+us+inet(evdev)+terminate(ctrl_alt_bksp)"
            key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
            key <AC02> { [ s, S, ssharp, U03A3 ] };
            key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
            key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
            include "level3(ralt_switch)"
        };
        xkb_geometry  { include "pc(pc104)" };
    };
  '';
in
{
    services.xserver = {
        # When X started, load the customized one
        displayManager.sessionCommands = ''
          ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${keymap} $DISPLAY
        '';
    };

    environment.systemPackages = with pkgs; [
        xorg.xkbcomp
    ];

    environment.etc."X11/keymap.xkb".source = keymap;
}
