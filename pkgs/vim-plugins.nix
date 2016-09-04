{ vimUtils, fetchgit, fetchFromGitHub }:
{
    base16-vim = vimUtils.buildVimPluginFrom2Nix {
          name = "base16-vim-2016-09-04";
          src = fetchFromGitHub {
              owner = "chriskempson";
              repo = "base16-vim";     
              rev = "acf210d5f62410b9b74ac142b7d9bd85cb7d41d4";
              sha256 = "08vjr5q56nd20yn0qmvipqf9ymww7ys0jwr0j7gvq4rgbpv5i0gi";
          };
          dependencies = [];
    };
}
