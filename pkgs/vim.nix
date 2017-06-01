{
  pkgs
}:
    let
        customPlugins = import ./vim-plugins.nix { inherit (pkgs) vimUtils fetchgit fetchFromGitHub ; };
    in pkgs.vim_configurable.customize {
        name = "vim";
        vimrcConfig.customRC = ''
            syntax enable
            set number

            set clipboard=unnamedplus

            let g:ctrlp_map = '<c-p>'
            let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

            let NERDTreeQuitOnOpen=1
            map <silent> <C-l> :NERDTreeToggle<CR>

            set smartindent
            set tabstop=4
            set shiftwidth=4
            set expandtab
            set softtabstop=4

            set backspace=2

            colorscheme base16-tomorrow
        '';
        vimrcConfig.vam.knownPlugins = pkgs.vimPlugins // customPlugins;
        vimrcConfig.vam.pluginDictionaries = [
            { names = [
                "vim-nix"
                "Syntastic"
                "The_NERD_tree"
                "ctrlp"
                "rust-vim"
                "vim-javascript-syntax"
                "vim-javascript"
                "youcompleteme"
                "base16-vim"
            ]; }
        ];
    }
