{ vimUtils, fetchgit, fetchFromGitHub }:
{
    base16-vim = vimUtils.buildVimPluginFrom2Nix {
          name = "base16-vim-2017-07-15";
          src = fetchFromGitHub {
              owner = "chriskempson";
              repo = "base16-vim";     
              rev = "c1c3e6ccb1a4cd4ea00162abb4ccece4a3e69d0b";
              sha256 = "0v4izy03aqarrympfn7yk7x2ybic8aplfigpikg8hb42f911z8n2";
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
