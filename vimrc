" Plugins
" ==========================
"
" Enable vim-plug
call plug#begin('~/.vim/plugged')

" Editor
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-endwise'
Plug 'vimlab/split-term.vim'
Plug 'gregsexton/MatchTag'

" Searching, Fuzzy find
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'

" Smarter editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'

" Testing
Plug 'janko-m/vim-test'

" Linting
Plug 'dense-analysis/ale'

" Git
Plug 'tpope/vim-fugitive'

" Colors
Plug 'dracula/vim'

" Language: Generic
Plug 'sheerun/vim-polyglot'
Plug 'Chiel92/vim-autoformat'


" Language: Ruby
Plug 'tpope/vim-rails'

call plug#end()

" Sensible Defaults
" =================

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
set visualbell " Use the visual bell, not audible bell
set nowrap " Disable wordwrap
autocmd FileType markdown setlocal wrap " Except... on Markdown. That's good stuff.
set number " Show line numbers
set ignorecase " Ignore case by default when searching
set smartcase " Search case-sensitive if a capital is used
set encoding=utf8
set nocursorline!
set lazyredraw
set noshowcmd
set autoindent


" Only highlight current line in active buffer
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

set nobackup " do not attempt to backup
set nowritebackup " dont write backup files
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

" Colorscheme
set colorcolumn=80,120 " column width helper
colorscheme dracula

" Macvim settings
autocmd! GUIEnter * set vb t_vb= " Disable bells
set guioptions= " Disable scrollbars

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

" ========================================================

" Plugin: NERDCommenter
" =====================
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" Plugin: vim-test
" ================
let test#strategy = "vimterminal"
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Plugin: vim-fugitive
" ====================
nnoremap <Leader>gb :Gblame<CR>

" Plugin: Ale
" ==========
let g:ale_linters = {
      \   'javascript': ['eslint'],
      \   'ruby': ['rubocop']
      \}
let g:ale_fixers = {
      \   'javascript': ['eslint'],
      \   'ruby': ['rubocop']
      \}
let g:ale_fix_on_save = 1
let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper'

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

" Plugin: Ack.vim
" ===============
let g:ackprg = 'ag --vimgrep'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nnoremap <Leader>f :Ack<Space>
nnoremap <C-f> :Ack<Space>

" Plugin: CtrlP
" =============
nnoremap <C-o> :CtrlP<CR>
nnoremap <D-p> :CtrlP<CR>
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0 " diable caching since `ag` is fast

" Plugin: vim-javascript
" ================
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" Plugin: vim-jsdoc
" ================
let g:jsdoc_enable_es6=1
let g:jsdoc_underscore_private=1
nmap <silent> <C-l> <Plug>(jsdoc)

" Plugin: LanguageServerClient
" ============================
let g:LanguageClient_serverCommands = {
      \ 'ruby': ['~/.asdf/shims/solargraph', 'stdio'],
      \ }

" Plugin: vim-autoformat
" ======================
au BufWrite * :Autoformat " Auto format on save

" Plugin: split-term
" ======================
set splitright " Open the vertical terminal to the right
set shell=zsh " Ensure we use zsh
