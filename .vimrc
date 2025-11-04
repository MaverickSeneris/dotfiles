" Set Space as leader key
let mapleader = " "


" Enable syntax highlighting and filetype detection
syntax on
filetype plugin indent on

" Status Line config:
set laststatus=2
set statusline=%f\ %y\ %m%r%h%w\ [%{&fileencoding}]\ [%{&fileformat}]\ %l:%c

" Show absolute line number for the current line
set number

" Show relative line numbers for fast jumping (5j, 10k, etc.)
set relativenumber

" Tab settings for JavaScript: 2-space indentation standard
set tabstop=2        " How many spaces a tab counts for
set shiftwidth=2     " Indent width when shifting/auto-indent
set expandtab        " Convert tabs to spaces (holy practice)

set ignorecase       " Case-insensitive search...
set smartcase        " ...unless CAPS present, then be precise
set incsearch        " Highlight as you type search queries
set hlsearch         " Highlight all search matches
" Show absolute line number for the current line
set number

" Show relative line numbers for fast jumping (5j, 10k, etc.)
set relativenumber

" Tab settings for JavaScript: 2-space indentation standard
set tabstop=2        " How many spaces a tab counts for
set shiftwidth=2     " Indent width when shifting/auto-indent
set expandtab        " Convert tabs to spaces (holy practice)

" Smarter searching
set ignorecase       " Case-insensitive search...
set smartcase        " ...unless CAPS present, then be precise
set incsearch        " Highlight as you type search queries
set hlsearch         " Highlight all search matches


" Key bindings with <leader>
" ------------------------
" Fuzzy find with <leader>f (Space + f)
nnoremap <leader>f :Files<CR>
" Buffer navigation
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>d :bdelete<CR>
" Easy write and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" PLUGINS
"-----------------------
" Plugin system start
call plug#begin('~/.vim/plugged')

" Fuzzy finder core
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" PLUGINS
"-----------------------
" Plugin system start
call plug#begin('~/.vim/plugged')

" Fuzzy finder core
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Auto-format on save
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

call plug#end()

" Format on save
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.json Prettier
" Auto-format on save:
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
call plug#end()


"------------------------
" Theme settings
" -----------------------
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
call plug#end()

set termguicolors
set background=dark
colorscheme gruvbox

" Toggle netrw: if any netrw window exists, close it; else open it
function! ToggleNetrw()
  " Look through all windows for a netrw buffer
  for w in range(1, winnr('$'))
    let bnr = winbufnr(w)
    if getbufvar(bnr, '&filetype') ==# 'netrw'
      execute w . 'wincmd w'   " jump to that window
      bd                       " close the netrw buffer/window
      return
    endif
  endfor
  " None found → open explorer (left sidebar version is nice)
  Lexplore
endfunction

" Map Space+e to toggle
nnoremap <leader>e :call ToggleNetrw()<CR>

" Toggle terminal with <leader>/
function! ToggleTerminal()
  " Check if a terminal window already exists
  for w in range(1, winnr('$'))
    let bnr = winbufnr(w)
    if getbufvar(bnr, '&buftype') ==# 'terminal'
      execute w . 'wincmd w'   " jump to terminal window
      bd                       " close it
      return
    endif
  endfor

  " No terminal found — open one
  split | terminal
endfunction

nnoremap <leader>/ :call ToggleTerminal()<CR>

