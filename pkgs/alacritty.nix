{ pkgs, theme }:
let
    normalColors = theme.colors.normal;
    brightColors = theme.colors.bright;
    configFile = pkgs.writeText "alacritty.yml" ''
        window:
            dimensions:
                columns: 0
                lines: 0
            padding:
                x: 5
                y: 5
            decorations: true
        tabspaces: 4
        font:
            normal:
                family: ${theme.fonts.mono}
                style: Regular
            bold:
                family: ${theme.fonts.mono}
                style: Bold
            italic:
                family: ${theme.fonts.mono}
                style: Italic
            size: ${theme.fonts.size}.0
            offset:
                x: 0
                y: 0
            glyph_offset:
                x: 0
                y: 0
            scale_with_dpi: false
            use_thin_strokes: true
        colors:
            primary:
                background: '0x${normalColors.background}'
                foreground: '0x${normalColors.foreground}'
            cursor:
                text: '0x000000'
                cursor: '0xffffff'
            normal:
                black:   '0x${normalColors.black}'
                red:     '0x${normalColors.red}'
                green:   '0x${normalColors.green}'
                yellow:  '0x${normalColors.yellow}'
                blue:    '0x${normalColors.blue}'
                magenta: '0x${normalColors.magenta}'
                cyan:    '0x${normalColors.cyan}'
                white:   '0x${normalColors.white}'
            bright:
                black:   '0x${normalColors.black}'
                red:     '0x${normalColors.red}'
                green:   '0x${normalColors.green}'
                yellow:  '0x${normalColors.yellow}'
                blue:    '0x${normalColors.blue}'
                magenta: '0x${normalColors.magenta}'
                cyan:    '0x${normalColors.cyan}'
                white:   '0x${normalColors.white}'
    '';

in
pkgs.stdenv.mkDerivation {
    name = "alacritty-styled";
    src = null;
    buildInputs = [ pkgs.alacritty pkgs.makeWrapper ];
    unpackPhase = "true";
    installPhase = ''
        makeWrapper ${pkgs.alacritty}/bin/alacritty $out/bin/alacritty \
            --add-flags "--config-file ${configFile}"
    '';
}