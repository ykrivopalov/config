" reset
autocmd!

" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" Vundle options
filetype off
set rtp+=$HOME/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'camelcasemotion'
Bundle 'bufexplorer.zip'
Bundle 'bufkill.vim'
Bundle 'gtags.vim'
Bundle 'vcscommand.vim'
Bundle 'lukerandall/haskellmode-vim'
Bundle 'guns/xterm-color-table.vim'
Bundle 'tpope/vim-rsi'
Bundle 'mhinz/vim-startify'

filetype plugin indent on     " required! 


" russian
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1

if has('win32')
  set guifont=Consolas:h10:cRUSSIAN
  "set encoding=utf-8
endif


" edit
filetype plugin on
set autoindent
set shiftwidth=2
set expandtab
set tabstop=8
set softtabstop=2
set smarttab
set showbreak=>
if has("gui") && version >= 703
  set colorcolumn=80
endif
set backspace=indent,eol,start
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" substitution mappings
map <Leader>ss :%s/
map <Leader>sw :%s/<C-R><C-W>//g<left><left>
map <Leader>sW :%s//<C-R><C-W>/g<home><right><right><right>
map <Leader>sf :.,$s/<C-R><C-W>//gc<left><left><left>
map <Leader>sF :.,$s//<C-R><C-W>/gc<home><right><right><right><right><right>

map <Leader>td $a /// @todo<Esc>
map <Leader>te othrow Common::Error(); /// @todo<Esc>

" shortcuts
map <Leader>w :w<Enter>
map <Leader>e :e<Enter>
map <Leader>n :noh<Enter>

function! PwdCopy()
  redir @p | pwd | redir END
endfunction

" view
color desert
syntax on
highlight ColorColumn guibg=grey25
highlight Pmenu guibg=#5f875f guifg=#262626
highlight PmenuSel guibg=#949494 guifg=#262626
set ruler
set guioptions-=T
set guioptions-=l
set guioptions-=r
set guioptions-=b
set guioptions-=L
set guioptions-=m
set guioptions+=c
set guicursor+=a:blinkon0

set hlsearch
set incsearch


" work
set autochdir
" autocmd BufEnter * silent! lcd %:p:h
set hidden

if has('unix')
  set directory=~/tmp,/var/tmp,/tmp
  set backupdir=~/tmp,~/
elseif has('win32')
  set directory=c:/tmp,c:/temp
  set backupdir =c:/tmp,c:/temp
endif


" plugins maps
map <C-p> :BB<CR>
map <C-n> :BF<CR>

map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

map <C-\> :cclose<CR>:GtagsCursor<CR>
map <F3> :cclose<CR>:Gtags<SPACE>

" for c++
set cinoptions+=g0 " for public/private indent
" Add highlighting for function definition in C++
function! EnhanceCppSyntax()
  syn match    cCustomParen    "(" contains=cParen contains=cCppParen
  syn match    cCustomFunc     "\w\+\s*(" contains=cCustomParen
  syn match    cppCustomScope    "::"
  syn match    cppCustomClass    "\w\+\s*::" contains=cCustomScope
  hi def link cCustomFunc  Function
endfunction

autocmd Syntax cpp call EnhanceCppSyntax()


" for haskell
if has('unix')
  autocmd BufEnter *.hs compiler ghc
  let g:haddock_browser="/usr/bin/firefox"
endif
autocmd BufEnter *.{hs,cabal} setlocal shiftwidth=4
autocmd BufEnter *.{hs,cabal} setlocal softtabstop=4
autocmd BufEnter *.{hs,cabal} setlocal cmdheight=1

" for python
autocmd BufEnter *.{py} setlocal shiftwidth=4
autocmd BufEnter *.{py} setlocal softtabstop=4


" trailing spaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd BufWinEnter *.{c,h,cpp,hpp,ion,hs,py} match ExtraWhitespace /\s\+$/
autocmd InsertEnter *.{c,h,cpp,hpp,ion,hs,py} match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave *.{c,h,cpp,hpp,ion,hs,py} match ExtraWhitespace /\s\+$/
autocmd BufWinLeave *.{c,h,cpp,hpp,ion,hs,py} call clearmatches()

function! Unixify()
  set ff=unix
  s#\\#\/#g
endfunction

" python scripting
python << endpython
from itertools import imap
import vim

def findfile(title, extension='', paths='.'):
  if extension:
    return vim.eval('findfile("{}.{}", "{}")'.format(title, extension, paths))
  else:
    return vim.eval('findfile("{}", "{}")'.format(title, paths))

def first_evaluated(function, input):
  return next((x for x in imap(function, input) if x), None)

def switch_source_header():
  name = vim.eval('expand("%:t")')
  title = vim.eval('expand("%:t:r")')
  extension = vim.eval('expand ("%:e")')

  if extension == 'txt':
    new_path = findfile("text.h")
  elif name == 'text.h':
    new_path = findfile("english.txt")
  elif extension in ['cpp', 'c']:
    find = lambda x : findfile(title, x, '.,..,include,../include')
    new_path = first_evaluated(find, ['h', 'hpp'])
  elif extension in ['h', 'hpp']:
    find = lambda x : findfile(title, x, '.,..,impl,../impl')
    new_path = first_evaluated(find, ['c', 'cpp'])
  else:
    print('Not supported file')
    return

  if new_path:
    vim.command('edit ' + new_path)
  else:
    print('Not found')
endpython

" Acronis CPP specific functions
nmap <F2> :python switch_source_header()<CR>

function! InsertHeader()
  normal! i/**
  normal! o
  normal! i@file
  normal! o@brief   .
  execute "normal! o@details Copyright (c) 2001-" . strftime("%Y") . " Acronis"
  normal! o@author  Yury Krivopalov (Yury.Krivopalov@acronis.com)
  normal! o@since   $Id$
  normal! o*/
endfunction

function! InsertXidlHeader()
  normal! i[author=Yury Krivopalov (Yury.Krivopalov@acronis.com)]
  normal! o[description=.]
  normal! o[header=]
  normal! o[body=]
endfunction

function! InsertPragmaOnce()
  normal! i#pragma once
endfunction

function! l:InsertCTemplate()
  call InsertHeader()
  normal! 2o
  normal! k
endfunction

function! l:InsertHTemplate()
  call InsertHeader()
  normal! 2o
  call InsertPragmaOnce()
  normal! 2o
  normal! k
endfunction

function! l:InsertXidlTemplate()
  call InsertXidlHeader()
  normal! 2o
  normal! k
endfunction

autocmd BufNewFile *.{h,hpp} call l:InsertHTemplate()
autocmd BufNewFile *.{c,cpp} call l:InsertCTemplate()
autocmd BufNewFile *.xidl call l:InsertXidlTemplate()

function! InitAcronisProject()
  let l:path = findfile('.is_acronis_project', '.;')
  if (empty(l:path))
    echo "Project file not found"
  else
    let l:path = fnamemodify(l:path, ":p:h")
    execute ':set path=' . '.,' . l:path . ',' . l:path . '/include,' . l:path . '/text'
  endif
endfunction

function! InitCabalProject()
  let l:path = globpath('.,..,../..,../../..', '*.cabal')
  if (empty(l:path))
    echo "Cabal file not found"
  else
    let l:path = fnamemodify(l:path, ":p:h")
    execute ':set path=' . '.,' . l:path
    execute ':set tags+=' . l:path . '/tags'
  endif
endfunction

