(
    with import <nixpkgs> {};

    vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''
            syntax enable
            set number
            set backspace=indent,eol,start

            let g:ctrlp_map = '<c-p>'
            let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

            set smartindent
        '';
        vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
        vimrcConfig.vam.pluginDictionaries = [
            { names = [
                "vim-nix"
                # "Syntastic"
                "The_NERD_tree"
                "ctrlp"
                # "rust-vim"
                # "youcompleteme"
                "vim-colorschemes"
            ]; }
        ];
    }
)
