" vim-plug modules here

" Bootstrap vim-plug, if necessary.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
let plugvim = $VIMUSERLOCALFILES . '/plug.vim'
let autoload_dir = data_dir . '/autoload'
if empty(glob(data_dir . '/autoload/plug.vim'))
    echom "Copying " plugvim . " to " . autoload_dir
    silent execute '!cp ' . plugvim . ' ' . autoload_dir
endif

let plugged = $VIMUSERLOCALFILES . '/plugged/'

let offline_mode = 1

call plug#begin(plugged)

if offline_mode
    " Vim or Nvim plugins (see below for git paths for online mode)
    Plug plugged . 'ranger.vim'
    Plug plugged . 'Align'

    " Add neovim plugins.
    if has('nvim')
        Plug plugged . 'nvim-notify'

        "Telescope
        Plug plugged . 'plenary.nvim'
        Plug plugged . 'telescope.nvim'
        Plug plugged . 'telescope-fzf-native.nvim'

        "File managers
        Plug plugged . 'nvim-tree.lua'

        "Lsp related
        Plug plugged . 'nvim-lspconfig'
        Plug plugged . 'nvim-cmp'
        Plug plugged . 'cmp-nvim-lsp'
        Plug plugged . 'cmp-nvim-lua'
        Plug plugged . 'cmp-buffer'
        Plug plugged . 'cmp_luasnip'

        "Required by ranger.vim
        Plug plugged . 'bclose.vim'

        "Nice colorscheme
        Plug plugged . 'nightfox.vim'
        Plug plugged . 'iceberg.vim'
        Plug plugged . 'melange'
        Plug plugged . 'sonokai'

        Plug plugged . 'undotree'

        " cscope_maps dependencies
        Plug plugged . 'cscope_maps.nvim'
        Plug plugged . 'which-key.nvim'

    endif
else
    " Vim or NVim plugins
    Plug 'francoiscabrol/ranger.vim'
    Plug 'vim-scripts/Align'

    "Plug 'davidhalter/jedi-vim'   "using pyls now. Keep for reference.

    " Add neovim plugins.
    if has('nvim')
        Plug 'rcarriga/nvim-notify'

        "Telescope
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim'
        Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

        "File managers
        Plug 'nvim-tree/nvim-tree.lua'

        "Lsp related
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-cmp'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-nvim-lua'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'saadparwaiz1/cmp_luasnip'

        "Required by ranger.vim
        Plug 'rbgrouleff/bclose.vim'

        "Nice colorschemes
        Plug 'EdenEast/nightfox.nvim'
        Plug 'cocopon/iceberg.vim'
        Plug 'savq/melange'
        Plug 'sainnhe/sonokai'

        Plug 'mbbill/undotree'

        " cscope_maps dependencies
        Plug 'dhananjaylatkar/cscope_maps.nvim'
        Plug 'folke/which-key.nvim'

    endif

endif

call plug#end()
