" This file is sourced early in Doc Mike's vimrc. This gives us the chance to
" disable plugins before calling pathogen#infect.
"
let g:EnableAle = 0
let g:EnableSyntastic = 0
let g:EnableVimLsp = 0

" Manually disable plugins installed by pathogen here.
"
" Example
"call add(g:pathogen_disabled, 'syntastic')


