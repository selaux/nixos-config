{ pkgs }:
with pkgs;
makeDesktopItem rec {
    name = "Spotify";
    exec = "nix-shell -p spotify --run 'spotify'";
    desktopName = name;
    genericName = "Spotify music player";
    categories = "Multimedia;";
}