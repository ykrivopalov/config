" reset
autocmd!

" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

call plug#begin('~/.config/nvim/plugged')
Plug 'FSwitch'
Plug 'bufexplorer.zip'
Plug 'camelcasemotion'
Plug 'gtags.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'jimsei/winresizer'
Plug 'justinmk/vim-gtfo'
Plug 'lyokha/vim-xkbswitch'
Plug 'majutsushi/tagbar'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'mhinz/vim-startify'
Plug 'moll/vim-bbye'
Plug 'morhetz/gruvbox'
Plug 'scrooloose/syntastic'
Plug 'ton/vim-bufsurf'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rsi'
Plug 'vcscommand.vim'
Plug 'ykrivopalov/vimcompletesme'
call plug#end()

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
set colorcolumn=80
set cursorline
set backspace=indent,eol,start
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let mapleader = "\<TAB>"
nnoremap <C-l> <C-i>

" substitution mappings
map <Leader>ss :%s/
map <Leader>sw :%s/<C-R><C-W>//g<left><left>
map <Leader>sW :%s//<C-R><C-W>/g<home><right><right><right>
map <Leader>sf :.,$s/<C-R><C-W>//gc<left><left><left>
map <Leader>sF :.,$s//<C-R><C-W>/gc<home><right><right><right><right><right>

map <Leader>td $a /// @todo<Esc>
map <Leader>te othrow Common::Error(LINE_TAG, 42); /// @todo<Esc>

" shortcuts
map <Leader>bd :bd<Enter>
map <Leader>Bd :Bdelete<Enter>
map <Leader>BD :Bdelete<Enter>
map <Leader>w :w<Enter>
map <Leader>e :e<Enter>
map <Leader>t :TagbarToggle<Enter>
map <Leader><Esc> :noh<Enter>
map ; :
map K <Nop>

function! PwdCopy()
  redir @p | pwd | redir END
endfunction

function! Unixify()
  set ff=unix
  %s#\\#\/#g
endfunction

" view
colorscheme gruvbox
set bg=dark
if !has("gui_running")
   let g:gruvbox_italic=0
endif

syntax on
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

set laststatus=2 " filename bottom

" autocomplete in command mode
set wildmode=longest,list,full
set wildmenu

set complete-=i

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
map <C-p> :BufSurfBack<CR>
map <C-n> :BufSurfForward<CR>

map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

map <C-\> :cclose<CR>:GtagsCursor<CR>
map <Leader><Leader>r :cclose<CR>:Gtags -r<SPACE>
map <Leader><Leader>d :cclose<CR>:Gtags -d<SPACE>
map <Leader><Leader>p :cclose<CR>:Gtags -P<SPACE>
map <Leader>p :call PwdCopy()<CR>
map <Leader>q :cclose<CR>
map - "+
map _ "+
map + "+

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
autocmd BufEnter *.{hs,cabal} setlocal shiftwidth=4
autocmd BufEnter *.{hs,cabal} setlocal softtabstop=4
autocmd BufEnter *.{hs,cabal} setlocal cmdheight=1

" for python
autocmd BufEnter *.{py} setlocal shiftwidth=4
autocmd BufEnter *.{py} setlocal softtabstop=4

" for markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:netrw_browsex_viewer = "xdg-open"

" trailing spaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd BufWinEnter *.{c,h,cpp,hpp,ion,hs,py,md} match ExtraWhitespace /\s\+$/
autocmd InsertEnter *.{c,h,cpp,hpp,ion,hs,py,md} match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave *.{c,h,cpp,hpp,ion,hs,py,md} match ExtraWhitespace /\s\+$/
autocmd BufWinLeave *.{c,h,cpp,hpp,ion,hs,py,md} call clearmatches()

function! Unixify()
  set ff=unix
  s#\\#\/#g
endfunction

function! GetVisualSelection()
  try
    let a_save = @a
    normal! gv"ay
    return @a
  finally
    let @a = a_save
  endtry
endfunction

" python scripting
if has('python')
python << endpython

from datetime import datetime
import vim

def convert_unixtime(unixtime):
  return datetime.fromtimestamp(unixtime).strftime('%Y-%m-%d %H:%M:%S')

def convert_windows_path(path):
  return '/smb' + path.replace('\\', '/').replace('//', '/')

def convert_unix_path(path):
  if path[:4] == 'smb:':
    path = path[4:]
  return path.replace('/', '\\')

def convert_path(path):
  if path.find('\\') != -1:
    path = convert_windows_path(path)
  else:
    path = convert_unix_path(path)
  print path

def convert_selected():
  path = vim.eval('GetVisualSelection()')
  result = ""
  if path.isdigit():
    result = convert_unixtime(int(path))
  else:
    result = convert_path(path)
  print result

endpython

  " time conversion helpers
  function! ConvertSelected()
    redir @+>
    python convert_selected()
    redir END
  endfunction

  vmap <Leader>vc :call ConvertSelected()<CR>
endif

" header/source switches
let g:fsnonewfiles = 'on'
autocmd BufEnter *.cpp let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = '.,..,include,../include'
autocmd BufEnter *.cc let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = '.,..,include,../include'
autocmd BufEnter *.c let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = '.,..,include,../include'
autocmd BufEnter *.h let b:fswitchdst = 'cpp,c,cc' | let b:fswitchlocs = '.,..,impl,../impl,src,../src'
autocmd BufEnter text.h let b:fullswitchdst = 'english.txt'
autocmd BufEnter english.txt let b:fullswitchdst = 'text.h'

function! FullSwitchFile()
  if exists('b:fullswitchdst')
    execute ":e " . b:fullswitchdst
  else
    execute ':FSHere'
  endif
endfunction

nmap <Leader>h :call FullSwitchFile()<CR>

" xkbswitch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/local/lib/libxkbswitch.so'
let g:XkbSwitchIMappings = ['ru']

" yankstack
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>n <Plug>yankstack_substitute_newer_paste

" new file skeleteons
autocmd BufNewFile *.cpp 0r ~/.config/nvim/skel/cpp.skel
autocmd BufNewFile *.h 0r ~/.config/nvim/skel/h.skel
autocmd BufNewFile *.ion 0r ~/.config/nvim/skel/ion.skel
autocmd BufNewFile *.xidl 0r ~/.config/nvim/skel/xidl.skel

let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_no_default_include_dirs = 1
let g:syntastic_cpp_compiler_options = '-std=c++03 -Wall -Wextra'
let g:syntastic_python_checkers = ['pep8', 'pylint', 'python']
let g:syntastic_python_pep8_args = "--ignore=E501"
let g:syntastic_python_pylint_args = "--rcfile=/home/yk/Develop/pylint.conf"
let g:syntastic_haskell_ghc_mod_exec = '/usr/local/bin/ghc-mod'

map <C-K> :pyf /usr/share/clang/clang-format.py<cr>
imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<cr>

nmap <Leader>ti :GhcModTypeInsert<CR>
nmap <Leader>tt :GhcModType<CR>

" copy current path
nmap cp :let @+ = expand("%:p")<CR>:let @" = expand("%:p")<CR>

function! InitAcronisProject()
  let l:path = findfile('family.xml', '.;')
  if (empty(l:path))
    echo "Project file not found"
  else
    let l:path = fnamemodify(l:path, ":p:h")
    execute ':set path=' . '.,' . l:path . ',' . l:path . '/include,' . l:path . '/text'
  endif
endfunction

command! InitProject call InitAcronisProject()

function! InitCabalProject()
  let l:path = globpath('.,..,../..,../../..', '*.cabal')
  if (empty(l:path))
    echo "Cabal file not found"
  else
    let l:path = fnamemodify(l:path, ":p:h")
    execute ':set path=' . '.,' . l:path . ',' . l:path . '/src'
    execute ':set tags+=' . l:path . '/tags'
  endif
endfunction
