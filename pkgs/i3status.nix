{ pkgs }:
''
general {
        output_format = "i3bar"
        colors = false
        color_good = "#b5bd68"
        color_degraded = "#f0c674"
        color_bad = "#cc6666"
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
