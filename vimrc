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
Plug 'janko-m/vim-test'
Plug 'tpope/vim-fugitive'
Plug 'chriskempson/base16-vim'
Plug 'pangloss/vim-javascript'
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'
Plug 'ternjs/tern_for_vim', { 'for': ['javascript'] }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript'], 'do': 'yarn global add tern' }
Plug 'othree/jspc.vim', { 'for': ['javascript'] }
Plug 'moll/vim-node'
Plug 'vimlab/split-term.vim'

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

" Colors
let base16colorspace=256
source ~/.vimrc_background
colorscheme base16-tomorrow-night
set colorcolumn=120 " column width helper

set clipboard=unnamedplus " yank to system clipboard

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
nnoremap <Leader>q :VTerm<CR>

" File Types
" ==========
au BufNewFile,BufRead *.ejs set filetype=html

" Plugin Configuration
" ====================

" Plugin: NERDTree
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.git$', '\.DS_Store$']
nnoremap <Leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Plugin: NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

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
let g:ctrlp_use_caching = 0 " diable caching since `ag` is fast

" Plugin: Neomake
autocmd! BufWritePost * Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
if findfile('.eslintrc', '.;') !=# ''
  let g:neomake_javascript_enabled_makers = ['eslint']
else
  let g:neomake_javascript_enabled_makers = ['standard']
endif

" Plugin: vim-test
let test#strategy = "neovim"
let test#runners = {'JavaScript': ['Mocha']}
let test#javascript#mocha#options = 'test/_setup/_setupSpec.js'
let test#javascript#mocha#executable = 'NODE_ENV=test ./node_modules/.bin/_mocha'
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" Plugin: vim-fugitive
nnoremap <Leader>gb :Gblame<CR>

" Plugin: vim-javascript
let g:javascript_plugin_jsdoc = 1

" Plugin: deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
set completeopt=longest,menuone,preview
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" Plugin: tern
let g:SuperTabClosePreviewOnPopupClose = 1

" Plugin: split-term
set splitright " Open the vertical terminal to the right
