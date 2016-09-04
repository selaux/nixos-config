(
    with import <nixpkgs> {};

    let customPlugins = import ./vim-plugins.nix { inherit (pkgs) vimUtils fetchgit fetchFromGitHub ; };
    in vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''
            syntax enable
            set number
            set backspace=indent,eol,start

            let g:ctrlp_map = '<c-p>'
            let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

            map <silent> <C-l> :NERDTreeToggle<CR>

            filetype plugin indent on
            set tabstop=4
            set shiftwidth=4
            set expandtab

            colorscheme base16-tomorrow-night
        '';
        vimrcConfig.vam.knownPlugins = vimPlugins // customPlugins;
        vimrcConfig.vam.pluginDictionaries = [
            { names = [
                "vim-nix"
                "Syntastic"
                "The_NERD_tree"
                "ctrlp"
                "rust-vim"
                # "youcompleteme"
                "base16-vim"
            ]; }
        ];
    }
)
