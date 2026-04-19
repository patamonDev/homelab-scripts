" Syntax highlighting
syntax on

" Show numberlines
set number

" Spaces instead of tabs
set expandtab
set tabstop=2
set shiftwidth=2

" Highlight search results
set hlsearch
set incsearch

" Set auto and smart indent
set autoindent
set smartindent

" Enable filetype detection
filetype plugin indent on

" 4 spaces for Shell scripts
autocmd FileType sh setlocal shiftwidth=4 tabstop=4 expandtab
