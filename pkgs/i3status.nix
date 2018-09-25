{ pkgs, theme }:
let
  normalColors = theme.colors.normal;
in
''
general {
        output_format = "i3bar"
        colors = false
        color_good = "#${normalColors.green}"
        color_degraded = "#${normalColors.yellow}"
        color_bad = "#${normalColors.red}"
        interval = 5
}

order += "disk /"
order += "battery_level"
order += "tztime local"

battery_level {
        threshold_bad = 10
        hide_seconds = true
        format = "Battery {percent}%"
}

tztime local {
        format = "%Y-%m-%d %H:%M"
}

disk "/" {
        format = "%free"
}
''
