" Set up Plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'luochen1990/rainbow'
Plug 'rainglow/vim'
Plug 'jiangmiao/auto-pairs'
Plug 'prettier/vim-prettier', {
    \ 'do': 'npm install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'tpope/vim-surround'
call plug#end()

"" Appearance
set termguicolors
set background=dark
syntax enable
set number
set cursorline
set linespace=3
set guifont=Fira\ Code:h12
highlight CursorLine cterm=None ctermbg=234 ctermfg=None
set autoindent
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set showmatch
set backspace=indent,eol,start
set visualbell

" Favorite colorschemes
silent! colorscheme elflord
silent! colorscheme glance

" Move vertically by visual line (take THAT line wraps!)
nnoremap j gj
nnoremap k gk
" Hey! You! No arrow keys!
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" more natural split-pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
" and more natural splits
set splitbelow
set splitright
" Tab between buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

set incsearch
set hlsearch
" hit spacebar to kill search highlights
nnoremap <space> :noh<return><esc>

" Functions
" Remove any trailing whitespace in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
" Reload changes to .vimrc automatically
autocmd BufWritePost  ~/.config/nvim/init.vim source ~/.config/nvim/init.vim
" Make text files prettier to look and and smoother to write in
autocmd FileType text setlocal wrap linebreak nolist cursorline!
autocmd FileType markdown setlocal wrap linebreak nolist cursorline!
" JavaScript wants different indents
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
" Limelight configs
let g:limelight_paragraph_span = 2
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#000000'
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
" Highlight React properly
autocmd BufEnter *.js set ft=javascript
" Automatically import Golang modules on save
let g:go_fmt_command = "goimports"
" Run prettier before saving
let g:prettier#autoformat = 0
autocmd BufWritePre *.ejs,*.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
" RustFmt all the time always
autocmd BufWritePre *.rs RustFmt

" Different filetypes deserve different colorschemes
"autocmd BufEnter *.md colorscheme comrade "frantic
"autocmd BufEnter *.js colorscheme glance
"autocmd BufEnter *.go colorscheme frantic
autocmd BufEnter *.rs colorscheme laravel
" use a light colorscheme if it's so daytime out
"let hour = strftime("%H")
"if hour > 7 && hour <= 17
"    colorscheme isotope-light
"endif
