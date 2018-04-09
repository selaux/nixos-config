{ pkgs, rofiMenus, theme }:
let
    inherit (theme) blue background foreground magenta cyan red gray;
in
''
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4
focus_follows_mouse no
hide_edge_borders both

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:DejaVu Sans 11

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec ${pkgs.gnome3.gnome_terminal}/bin/gnome-terminal

# Screenshots
bindsym Print       exec ${pkgs.gnome3.gnome-screenshot}/bin/gnome-screenshot
bindsym $mod+Print  exec ${pkgs.gnome3.gnome-screenshot}/bin/gnome-screenshot -i

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
bindsym $mod+d exec ${rofiMenus}/bin/application-menu
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right
bindsym $mod+Left focus left

bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# Lock Screen
bindsym $mod+Shift+l exec i3lock-fancy
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec ${rofiMenus}/bin/power-menu

# Brightness Controls
bindsym XF86MonBrightnessUp exec ${pkgs.xorg.xbacklight}/bin/xbacklight -inc 10
bindsym XF86MonBrightnessDown exec ${pkgs.xorg.xbacklight}/bin/xbacklight -dec 10

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym odiaeresis resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

client.focused ${blue} ${blue} ${background} ${blue} ${blue}
client.focused_inactive ${magenta} ${magenta} ${background} ${magenta} ${magenta}
client.unfocused ${background} ${background} ${foreground} ${background} ${background}
client.urgent ${red} ${red} ${foreground} ${red} ${red}
client.placeholder ${background} ${background} ${foreground} ${background} ${background}

bar {
    status_command py3status
    tray_output primary
    colors {
        separator ${foreground}
        background ${background}
        statusline ${foreground}
        focused_workspace ${blue} ${blue} ${background}
        active_workspace ${cyan} ${cyan} ${background}
        inactive_workspace ${background} ${background} ${foreground}
        urgent_workspace ${red} ${red} ${foreground}
    }
}

# Floating stuff
for_window [class="^firefox$"] floating disable

exec --no-startup-id ${pkgs.gnome3.networkmanagerapplet}/bin/nm-applet
exec --no-startup-id ${pkgs.pa_applet}/bin/pa-applet
exec --no-startup-id ${pkgs.dunst}/bin/dunst -conf /etc/xdg/dunstrc
exec --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${pkgs.gnome3.gnome-backgrounds}/share/backgrounds/gnome/Icescape.jpg
''
