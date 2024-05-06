:set number
:set tabstop=4
:set autoindent
:set clipboard+=unnamedplus

call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'https://github.com/terryma/vim-multiple-cursors'
call plug#end()

vnoremap <C-S-X> "+x
vnoremap <C-S-C> "+y
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-a> ggVG
let g:python3_host_prog = '/usr/bin/python3'

