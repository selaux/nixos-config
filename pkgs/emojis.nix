{}: ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>

    <!-- Add emoji generic family -->
    <alias binding="strong">
        <family>emoji</family>
        <default><family>Emoji One</family></default>
    </alias>

    <!-- Aliases for the other emoji fonts -->
    <alias binding="strong">
        <family>Apple Color Emoji</family>
        <prefer><family>Emoji One</family></prefer>
    </alias>
    <alias binding="strong">
        <family>Segoe UI Emoji</family>
        <prefer><family>Emoji One</family></prefer>
    </alias>
    <alias binding="strong">
        <family>Noto Color Emoji</family>
        <prefer><family>Emoji One</family></prefer>
    </alias>

    <!-- Do not allow any app to use Symbola, ever -->
    <selectfont>
        <rejectfont>
        <pattern>
            <patelt name="family">
            <string>Symbola</string>
            </patelt>
        </pattern>
        </rejectfont>
    </selectfont>
    </fontconfig>
''