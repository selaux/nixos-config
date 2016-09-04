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
    vim-javascript-syntax = vimUtils.buildVimPluginFrom2Nix {
          name = "vim-javascript-syntax-2016-09-04";
          src = fetchFromGitHub {
              owner = "jelera";
              repo = "vim-javascript-syntax";     
              rev = "9e019fccd738ba73713268a327ac3765646a4edd";
              sha256 = "04wbhsg6ybb3d1lxgidgqb16hbggsjj864gbd3fxp71vcja444qa";
          };
          dependencies = [];
    };
    vim-javascript = vimUtils.buildVimPluginFrom2Nix {
          name = "vim-javascript-2016-09-04";
          src = fetchFromGitHub {
              owner = "pangloss";
              repo = "vim-javascript";     
              rev = "782cc10782fabe8147fec8251b9df1abe783ff07";
              sha256 = "14b1q9wbisbm7818rhg807zqmr3cjlrq15m23azqxihn1rnpa33a";
          };
          dependencies = [];
    };
}
