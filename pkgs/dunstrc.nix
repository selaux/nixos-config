{ pkgs, theme }:
let
  inherit (theme) blue yellow red foreground background;
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
  frame_color = "${blue}"
  background = "${background}"
  foreground = "${foreground}"

  [urgency_normal]
  frame_color = "${yellow}"
  background = "${background}"
  foreground = "${foreground}"

  [urgency_critical]
  frame_color = "${red}"
  background = "${background}"
  foreground = "${foreground}"
''
