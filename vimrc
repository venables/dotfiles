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

" Searching, Fuzzy find
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Smarter editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'

" Testing
Plug 'janko-m/vim-test'

" Linting
" Plug 'w0rp/ale'

" Git
Plug 'tpope/vim-fugitive'

" Colors
Plug 'chriskempson/base16-vim'

" Language: Generic
" let g:polyglot_disabled = []
" Plug 'sheerun/vim-polyglot'
" Plug 'alexlafroscia/postcss-syntax.vim'


" Basic editor settings

if has('nvim')
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'vimlab/split-term.vim'
  " Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
else
  Plug 'tpope/vim-sensible'
  Plug 'noahfrederick/vim-neovim-defaults'

  " Plug 'Shougo/deoplete.nvim'
  " Plug 'roxma/nvim-yarp'
  " Plug 'roxma/vim-hug-neovim-rpc'
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

if has('nvim')
    set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175
endif

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
if has("termguicolors")
  set termguicolors
endif
set background=dark
set colorcolumn=80,120 " column width helper
if !has('gui_vimr')
  set guifont=Monaco:h13
endif

let base16colorspace=256  " Access colors present in 256 colorspace
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif
colorscheme base16-default-dark

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

" Python3
let g:python_host_prog = "/usr/local/bin/python"
let g:python3_host_prog = "/usr/local/bin/python3"
let g:ruby_path = system('echo $HOME/.asdf/shims')

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

" Plugin Configuration
" ====================

" Plugin: NERDTree
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
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" Plugin: Ack.vim
let g:ackprg = 'ag --vimgrep'
cnoreabbrev ag Ack
cnoreabbrev aG Ack
cnoreabbrev Ag Ack
cnoreabbrev AG Ack
nnoremap <Leader>f :Ack<Space>
nnoremap <C-f> :Ack<Space>

" Plugin: fzf.viim
nnoremap <C-o> :Files<CR>
nnoremap <C-p> :Files<CR>
" set grepprg=ag\ --nogroup\ --nocolor
" let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
" let g:ctrlp_use_caching = 0 " diable caching since `ag` is fast

" Plugin: vim-test
let test#strategy = "vimterminal"
if has('nvim')
  let test#strategy = "neovim"
endif
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Plugin: vim-fugitive
nnoremap <Leader>gb :Gblame<CR>


" Plugin: deoplete
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#file#enable_buffer_path = 1 " Relative file path autocomplete
" function! Multiple_cursors_before()
  " let b:deoplete_disable_auto_complete = 1
" endfunction

" function! Multiple_cursors_after()
  " let b:deoplete_disable_auto_complete = 0
" endfunction

" Plugin Ale
let g:ale_linters = {'javascript': ['eslint']} ", 'ruby': ['brakeman', 'reek', 'rubocop']}
let g:ale_fixers = {'javascript': ['eslint'], 'ruby': ['rubocop']}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_cache_executable_check_failures = 1
let g:ale_lint_on_enter = 0 
let g:ale_lint_on_filetype_changed = 0
" let g:ale_ruby_rubocop_options = '--force-exclusions'

" Plugin: coc.nvim
set hidden
set cmdheight=2 " Better display for messages
set updatetime=300 " You will have bad experience for diagnostic messages when it's default 4000.
set shortmess+=c " don't give |ins-completion-menu| messages.
set signcolumn=yes " always show signcolumns
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()


