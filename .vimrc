" Plugins
" (Install via :PlugInstall)
" ==========================
call plug#begin(has('nvim') ? '~/.local/share/nvim/plugged' : '~/.vim/plugged')

" Place plugins here
Plug 'scrooloose/nerdtree'

call plug#end()

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
syntax on " Enable syntax highlighting

" Plugin Configuration
" ====================

" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.git$']
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
