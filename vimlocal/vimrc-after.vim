"Remap Shift + Space to escape.
inoremap <S-Space> <Esc>

set nomodeline

set mouse=a
" Disable spell checking for all members of the "<source>" group:
" See Doc Mike's vimrc around line 5930
let g:SpellMap["<source>"] = "<off>"

" Set the status line the way I like it
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %2c\ Buf:\ #%2n\ [%b][0x%02B]

" Display line numbers on the left
set number
set numberwidth=5

" How I like the visibles to be displayed.
set listchars=eol:$,trail:.,tab:>-

" Shortcut to remove all trailing whitespace.
nnoremap <F10> :%s/\s\+$//<CR>
" Toggle display of visibles
nnoremap <F11> :set invlist<CR>

" Set a default colorsheme
colo szakdark

" Function for Neovim startup
function NvimStartup()
    if has('nvim')
        " If telescope is not installed, assume no plugins are installed.
        if !exists(":Telescope")
            PlugInstall --sync
        endif

        "Run initializations.
        lua require('user.init')

    endif
endfunction

"Call InstallPlugins after nvim is done initializing.
autocmd VimEnter * call NvimStartup()

" Source script which manages extra plugins not provided by base config.
"source ~/linuxconfig/vimlocal/plugins.vim
source $VIMUSERLOCALFILES/plugins.vim

" Custom plugins:
source $VIMUSERLOCALFILES/custom_plugins/docsync/plugin/docsync.vim
let g:Docsync_loglevel = "info"
let g:Docsync_enable_logging = 1


if $TERM == 'rxvt-unicode'
    "set t_Co=256
    set termguicolors
endif

" Set tab settings for filetypes:
autocmd Filetype htmldjango setlocal ts=4 sw=4 sts=4 expandtab
autocmd Filetype css setlocal ts=4 sw=4 sts=4 expandtab
autocmd Filetype proto setlocal ts=4 sw=4 sts=4 expandtab
autocmd Filetype matlab setlocal ts=4 sw=4 sts=4 expandtab

"-------------------------------------------------------------------------------
" Custom Functions/Commands
"-------------------------------------------------------------------------------

"Runs scriptnames command but puts the result in a buffer so it can be searched.
function! ShowLoadedPlugins()
    enew
    call InsertCmd('scriptnames')
endfunction
command! ShowLoadedPlugins call ShowLoadedPlugins()

"Inserts the output of vim command into buffer.
function! InsertCmd(command)
    pu=execute(a:command)
endfunction
command! -nargs=1 InsertCmd call InsertCmd(<args>)

"-------------------------------------------------------------------------------
" Plugin Specific: UltiSnips
" ------------------------------------------------------------------------------

let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"


"-------------------------------------------------------------------------------
" Plugin Specific: jedi python
" ------------------------------------------------------------------------------

" Need to set the omnifunc due to the Doc Mike's config overriding jedi with ale
" completions (in SetupPython fcn).
"au FileType python setlocal omnifunc=jedi#completions

"-------------------------------------------------------------------------------
" Plugin Specific: Ranger file manager
" ------------------------------------------------------------------------------
"let g:ranger_replace_netrw = 1

let g:undotree_WindowLayout=2
