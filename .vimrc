" Plugins
" (Install via :PlugInstall)
" ==========================
call plug#begin(has('nvim') ? '~/.local/share/nvim/plugged' : '~/.vim/plugged')

" Place plugins here
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'

call plug#end()

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
syntax on " Enable syntax highlighting

nnoremap <Leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <Leader>W :%s/^ *//g<Bar>:nohl<CR>
nnoremap <Leader>sv :source ~/.vimrc<CR>
nnoremap <Leader>ev :e ~/.vimrc<CR>


" Plugin Configuration
" ====================

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.git$']
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Ack.vim
" ======
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nnoremap <D-F> :Ack<Space>
