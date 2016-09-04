''general {
        output_format = "i3bar"
        colors = true
        color_good = "#b5bd68"
        color_degraded = "#f0c674"
        color_bad = "#cc6666"
        interval = 5
}

order += "disk /"
order += "wifi wlan0"
order += "ethernet eth0"
order += "battery_level"
order += "tztime local"

wifi wlan0 {
        device wlp3s0
        format_up = "Wifi: {signal_percent} at {ssid}, {bitrate}"
        format_down = "Wifi: down"
        bitrate_degraded = 26
        bitrate_bad = 4
}

ethernet eth0 {
        # if you use %speed, i3status requires the cap_net_admin capability
        format_up = "Ethernet: %ip (%speed)"
        format_down = "Ethernet: down"
}

battery_level {
        threshold_bad = 10
        hide_seconds = true
        format = "Battery {percent}% {time_remaining} remaining"
}

tztime local {
        format = "%Y-%m-%d %H:%M"
}

disk "/" {
        format = "%free"
}''
