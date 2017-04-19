" Plugins
" (Install via :PlugInstall)
" ==========================
call plug#begin('~/.local/share/nvim/plugged')

" Place plugins here
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'

call plug#end()

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
syntax on " Enable syntax highlighting
filetype plugin on " Enable filetype plugins

nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap <Leader>sv :source ~/.vimrc<CR>
nnoremap <Leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <Leader>W :%s/^ *//g<Bar>:nohl<CR>


" Plugin Configuration
" ====================

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.git$']
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDCommenter
let g:NERDSpaceDelims = 1

" Ack.vim
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nnoremap <Leader>f :Ack<Space>
nnoremap <C-f> :Ack<Space>

" CtrlP
nnoremap <C-o> :CtrlP<CR>
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
