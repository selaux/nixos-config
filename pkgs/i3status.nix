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
order += "battery all"
order += "tztime local"

battery all {
        low_threshold = 15
        format = "%status %percentage"
        threshold_type = "percentage"
}

tztime local {
        format = "%Y-%m-%d %H:%M"
}

disk "/" {
        format = "%free"
}
''
