" Enable vim-plug
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'janko-m/vim-test'

call plug#end()

" Sensible Defaults
" =================

set encoding=utf8 " Set standard file encoding
set nomodeline " No special per file vim override configs
set nowrap " Stop word wrapping
  autocmd FileType markdown setlocal wrap " Except... on Markdown. That's good stuff.
set undolevels=100 " Adjust system undo levels
set clipboard=unnamed " Use system clipboard
set tabstop=2 " Set tab width and convert tabs to spaces
set softtabstop=2
set shiftwidth=2
set expandtab
set conceallevel=1 " Don't let Vim hide characters or make loud dings
set noerrorbells
set number " Number gutter
set hlsearch " Use search highlighting
set scrolloff=1 " Space above/beside cursor from screen edges
set sidescrolloff=5
set noswapfile " Prevent creating a swapfile (.swp)
set number " Show line numbers
set ignorecase " Ignore case by default when searching
set smartcase " Search case-sensitive if a capital is used
set nocursorline!
set lazyredraw
set noshowcmd
" Only highlight current line in active buffer
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END
set nobackup " do not attempt to backup
set nowritebackup " dont write backup files
set background=dark
set colorcolumn=80,120 " column width helper
set mouse=a
" Set the cursort to blink
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon17

" Stop using arrow keys
nnoremap <Left> :vertical resize -1<CR>
nnoremap <Right> :vertical resize +1<CR>
nnoremap <Up> :resize -1<CR>
nnoremap <Down> :resize +1<CR>
" Disable arrow keys completely in Insert Mode
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" Clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

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
nnoremap <Leader>sv :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>w :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <Leader>W :%s/^ *//g<Bar>:nohl<CR>
" Set `Leader q` to open a terminal
nnoremap <Leader>q :VTerm<CR>

" Allow capital letters for saving, quitting
" https://sanctum.geek.nz/arabesque/vim-command-typos/
if has("user_commands")
  command! -bang -nargs=? -complete=file E e<bang> <args>
  command! -bang -nargs=? -complete=file W w<bang> <args>
  command! -bang -nargs=? -complete=file Wq wq<bang> <args>
  command! -bang -nargs=? -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang QA qa<bang>
  command! -bang Qa qa<bang>
endif


" Plugin: NERDCommenter
" =====================
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" Plugin: vim-test
" ================
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
