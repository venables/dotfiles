" Plugins
" (Install via :PlugInstall)
" ==========================
call plug#begin(has('nvim') ? '~/.local/share/nvim/plugged' : '~/.vim/plugged')

" Place plugins here

call plug#end()

" Configuration
" =============
set noswapfile " Prevent creating a swapfile (.swp)
syntax on " Enable syntax highlighting
