" Enable vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/denite.nvim'
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-grepper'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
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

" Python3
let g:python_host_prog = "/usr/local/bin/python"
let g:python3_host_prog = "/usr/local/bin/python3"
let g:ruby_path = system('echo $HOME/.asdf/shims')

" Double tap Ledaer to open previous file buffer
nmap <Leader><Leader> <c-^>


" Tab to swithc to next buffer, Shift+Tab to go back
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprev!<CR><Paste>

" Plugin: base16-vim
" ==================
set termguicolors
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
color base16-eighties
" color base16-default-dark

" Plugin: indentLine
" ==================
let g:indentLine_enabled = 1

" Plugin: vim-airline
" ===================
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
set laststatus=2

" Plugin: vim-grepper
" ===================
nnoremap <Leader>f :Grepper<Space>-query<Space>
nnoremap <C-f> :Grepper<Space>-query<Space>

" Plugin: fzf.vim
" ================
nnoremap <C-o> :Files<CR>
nnoremap <C-p> :Files<CR>

" Plugin: defx
" ============
map ` :Defx -explorer<CR>
map ~ :Defx -explorer -find<CR>

" Plugin: deoplete
" ================
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Plugin: vim-sneak
" =================
let g:sneak#s_next = 1
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

" Plugin: fugitive
" ================
nnoremap <Leader>gb :Gblame<CR>

" Plugin: NERDTree
" ================
let NERDTreeShowHidden = 1
let NERDTreeIgnore = [
      \ '\.git$',
      \ '\.DS_Store$',
      \ '\.tern-port$',
      \ '\.vscode$',
      \ '_build$',
      \ '_data$'
      \ ]
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

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

" Plugin Ale
" ==========
let g:ale_linters = {'javascript': ['eslint']} ", 'ruby': ['brakeman', 'reek', 'rubocop']}
let g:ale_fixers = {'javascript': ['eslint'], 'ruby': ['rubocop']}
let g:ale_fix_on_save = 1

