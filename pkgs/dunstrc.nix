{ pkgs }:
let
  iconSubFolders = [ "status" "devices" "actions" ];
  iconFolders = builtins.foldl' (all: sub: all + "${pkgs.gnome2.gnome_icon_theme}/share/icons/gnome/48x48/${sub}/:") "" iconSubFolders;
in
''
[global]
  font = DejaVu Sans Mono 11
  markup = full
  geometry = "900x3-60+60"
  separator_height = 2
  padding = 15
  horizontal_padding = 15
  alignment = center
  word_wrap = tes
  frame_width = 4

  icon_position = right
  icon_folders = ${iconFolders}

  [urgency_low]
  frame_color = "#81a2be"
  background = "#1d1f21"
  foreground = "#c5c8c6"

  [urgency_normal]
  frame_color = "#f0c674"
  background = "#1d1f21"
  foreground = "#c5c8c6"

  [urgency_critical]
  frame_color = "#cc6666"
  background = "#1d1f21"
  foreground = "#c5c8c6"
''
