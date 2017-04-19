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
Plug 'neomake/neomake'

call plug#end()

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
set visualbell " Use the visual bell, not audible bell
set nowrap " Disable wordwrap
set number " Show line numbers
set cursorline " Highlight the current line
set ignorecase " Ignore case by default when searching
set smartcase " Search case-sensitive if a capital is used

" set showcmd " Show incomplete commands (lines highlighted, etc) (on by
" default) (on by default)

" Only highlight current line in active buffer
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Don't write backup files
set nobackup " do not attempt to backup
set nowritebackup " dont write backup files

set colorcolumn=120 " column width helper

" Set tabs to 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Show tabs as ▸, trailing whitespace as ·
set listchars=tab:▸\ ,trail:·
set list

" Always jump to the first line when opening a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

nnoremap <Leader>b :buffers<CR>:buffer<Space>
nnoremap <Leader>sv :source ~/.vimrc<CR>
nnoremap <Leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <Leader>W :%s/^ *//g<Bar>:nohl<CR>

" Plugin Configuration
" ====================

" Plugin: NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.git$']
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Plugin: NERDCommenter
let g:NERDSpaceDelims = 1

" Plugin: Ack.vim
let g:ackprg = 'ag --vimgrep --smart-case'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nnoremap <Leader>f :Ack<Space>
nnoremap <C-f> :Ack<Space>

" Plugin: CtrlP
nnoremap <C-o> :CtrlP<CR>
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Plugin: Neomake
autocmd! BufWritePost * Neomake
