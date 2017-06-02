with import <nixpkgs> {};
{
    vim = callPackage ./pkgs/vim.nix {};
    evolution = callPackage ./pkgs/evolutionEws.nix {};
}