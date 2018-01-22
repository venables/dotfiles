" Plugins
" (Install via :PlugInstall)
" ==========================
if has('nvim')
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" Editor
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Searching, Fuzzy find
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'

" Smarter editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-endwise'
Plug 'jiangmiao/auto-pairs'
Plug 'ervandew/supertab'

" Testing
Plug 'janko-m/vim-test'

" Linting
Plug 'w0rp/ale'

" Git
Plug 'tpope/vim-fugitive'

" Tags
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'
Plug 'jakedouglas/exuberant-ctags'
Plug 'majutsushi/tagbar'

" Colors
Plug 'chriskempson/base16-vim'

" Language: Elixir
" Plug 'mmorearty/elixir-ctags'
" Plug 'elixir-lang/vim-elixir'
" Plug 'avdgaag/vim-phoenix'
" Plug 'slashmili/alchemist.vim'

" Language: Javascript
Plug 'pangloss/vim-javascript'
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim'
Plug 'mxw/vim-jsx'
Plug 'posva/vim-vue'
Plug 'Quramy/vim-js-pretty-template'

" Language: Generic
let g:polyglot_disabled = ['javascript', 'jsx', 'vue'] " , 'elixir'
Plug 'sheerun/vim-polyglot'

" Basic editor settings

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'vimlab/split-term.vim'
else
  Plug 'tpope/vim-sensible'
  Plug 'noahfrederick/vim-neovim-defaults'

  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()

" Vim Configuration
" =================
set noswapfile " Prevent creating a swapfile (.swp)
set visualbell " Use the visual bell, not audible bell
set nowrap " Disable wordwrap
set number " Show line numbers
set ignorecase " Ignore case by default when searching
set smartcase " Search case-sensitive if a capital is used
set encoding=utf8
set nocursorline!
set lazyredraw
set noshowcmd

" Only highlight current line in active buffer
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Don't write backup files
set nobackup " do not attempt to backup
set nowritebackup " dont write backup files

" Colors
set background=dark
set termguicolors
colorscheme base16-tomorrow-night
set colorcolumn=120 " column width helper

" Font (via nerdfonts.com)
if !has("gui_vimr")
  set guifont=Source\ Code\ Pro\ Nerd\ Font\ Complete:h14
endif

" Plugin: Airline:
" Rounded symbols
let g:airline_left_sep = "\uE0B4"
let g:airline_right_sep = "\uE0B6"
let g:airline_theme='tomorrow'
let g:airline_powerline_fonts = 1
" set the CN (column number) symbol:
let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

" Clipboard
if !has("gui_running")
  set clipboard=unnamedplus " yank to system clipboard
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


" Map CTRL-o to exit terminal insert mode
if has('nvim')
  tmap <C-o> <C-\><C-n>
end

" GUI-Specific options (MacVim)
if has("gui_running")
  " Fullscreen (<Leader>f and Command+Enter)
  nnoremap <Leader>f :set invfu<CR>
  nnoremap <D-CR> :set invfu<CR>

  " Use minimal window settings (no scrollbar)
  set guioptions=aAce
endif

" Mouse
" =====
set mouse=a

" File Types
" ==========
au BufNewFile,BufRead *.ejs set filetype=html

" Plugin Configuration
" ====================

" Plugin: vim-alchemist
let g:alchemist_iex_term_split = 'split'
let g:alchemist_tag_disable = 1
nnoremap <Leader>i :IEx<CR>

" Plugin: goyo
nnoremap <Leader>z :Goyo<CR>

" Plugin: NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = [
      \ '\.git$',
      \ '\.DS_Store$',
      \ '\.tern-port$',
      \ '\.elixir_ls$',
      \ '\.vscode$',
      \ '_build$',
      \ '_data$'
      \ ]
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Plugin: Tagbar
nnoremap <Leader>m :TagbarToggle<CR>
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records',
        \ 't:tests'
    \ ]
    \ }

" Plugin: NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" Plugin: Ack.vim
let g:ackprg = 'ag --nogroup --nocolor'
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
let g:ctrlp_use_caching = 0 " diable caching since `ag` is fast

" Plugin: vim-test
if has('nvim')
  let test#strategy = "neovim"
endif

if filereadable('test/_setup/setupSpec.js')
  let test#javascript#mocha#options = 'test/_setup/_setupSpec.js'
endif
let test#filename_modifier = ":p"
let test#runners = {'JavaScript': ['Mocha']}
let test#javascript#mocha#executable = 'NODE_ENV=test TZ=UTC ./node_modules/.bin/mocha'

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Plugin: vim-fugitive
nnoremap <Leader>gb :Gblame<CR>

" Plugin: vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" Plugin: deoplete
let g:deoplete#enable_at_startup = 1
function! Multiple_cursors_before()
  let b:deoplete_disable_auto_complete = 1
endfunction

function! Multiple_cursors_after()
  let b:deoplete_disable_auto_complete = 0
endfunction


" Plugin: tern
let g:SuperTabClosePreviewOnPopupClose = 1

" Plugin: split-term
set splitright " Open the vertical terminal to the right
set shell=zsh " Ensure we use zsh

" Plugin: vim-easytags
let g:easytags_async=1
let g:easytags_auto_highlight=0
