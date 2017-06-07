" reset all autocommands (for safe vimrc reloading)
autocmd!

set nocompatible  " Use Vim settings, rather than Vi settings


" vim-plug pluggins
call plug#begin('~/.config/nvim/plugged')
Plug 'FSwitch'  " switching between header and source
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " keyword completion
Plug 'bkad/CamelCaseMotion'  " motion through CamelCaseWords
Plug 'bufexplorer.zip'  " buffers explorer
Plug 'embear/vim-localvimrc'  " .localvimrc support
Plug 'gtags.vim'  " support for GNU global tags system
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }  " fuzzy file finder
Plug 'lyokha/vim-xkbswitch'  " automatic keyboard layout switching in insert mode
Plug 'majutsushi/tagbar'  " displays tags in a window, ordered by scope
Plug 'maxbrunsfeld/vim-yankstack'  " cached ring of yanks
Plug 'moll/vim-bbye'  " delete buffers without closing windows 
Plug 'dkasak/gruvbox'  " color scheme (it's fork with better haskell support)
Plug 'neomake/neomake'  " asynchronous linting and make
Plug 'rust-lang/rust.vim'  " rust file detection, syntax highlighting, formatting
Plug 's3rvac/AutoFenc'  " automatically detect and set file encoding when opening a file.
Plug 'simeji/winresizer'  " easy resizing of vim windows
Plug 'ton/vim-bufsurf'  " surfing through buffers based on viewing history
Plug 'tpope/vim-commentary'  " comment stuff out
Plug 'tpope/vim-rsi'  " readline key bindings
Plug 'vcscommand.vim'  " VCS integration
Plug 'zchee/deoplete-clang'  " C/C++ source for deoplete
Plug 'neovimhaskell/haskell-vim'  " haskell syntax highlighting
call plug#end()


" russian
set keymap=russian-jcukenwin  " russian keyboard mapping
set iminsert=0  " disable vim's input method switching for insert
set imsearch=-1  " disable vim's input method switching for search

if has('win32')
  set guifont=Consolas:h10:cRUSSIAN  " proper font for Windows
endif


" filetype detection
filetype on  " enable file type detection
filetype plugin on  " loading the plugins for specific file types
filetype indent on  " loading the indent file for specific file types

syntax on  " syntax highlighting

" identing and tabbing
set autoindent
set expandtab  " insert spaces instead of <Tab> in insert mode
set shiftwidth=2  " number of spaces to use for each step of (auto)indent
set smarttab  " delete spaces count of <Tab> size
set softtabstop=2  " number of spaces that a <Tab> counts for while performing editing
set tabstop=8  " number of spaces that a <Tab> in the file counts for


" behavior
set autochdir  " chage current working directory whenever file opened
set backspace=start,indent,eol  " backspacing over start of insert, autoindent, line breaks
set hidden  " don't unload abandoned buffers
set hlsearch  " higlight all search matches
set incsearch  " show matches while typing
set tags=tags;  " show tags upward from current dir
set wildmenu  " autocomplete in command mode
set wildmode=longest,list,full


" status line
set colorcolumn=80  " column highlighting
set cursorline  " current line highlighting
set laststatus=2  " always show a status line
set ruler  " show the line and column number
set showbreak=>  " symbol that indetifies line start after break


" GVim UI setup
set guicursor+=a:blinkon0
set guioptions+=c
set guioptions-=L
set guioptions-=T
set guioptions-=b
set guioptions-=l
set guioptions-=m
set guioptions-=r


" temp files placement
if has('unix')
  set directory=~/tmp,/var/tmp,/tmp
  set backupdir=~/tmp,/var/tmp,/tmp
elseif has('win32')
  set directory=c:/tmp,c:/temp
  set backupdir =c:/tmp,c:/temp
endif


" color scheme setup
colorscheme gruvbox
set background=dark
if !has("gui_running")
   let g:gruvbox_italic=0
endif


let mapleader = "\<Tab>"  " alias for the <Leader> key
" remap for <C-i>, because it interpreted by Vim as a <Tab>
nnoremap <C-l> <C-i>


" substitution mappings
map <Leader>ss :%s/
map <Leader>sf :.,$s/<C-R><C-W>//gc<left><left><left>
map <Leader>sF :.,$s//<C-R><C-W>/gc<home><right><right><right><right><right>
map <Leader>sw :%s/<C-R><C-W>//g<left><left>
map <Leader>sW :%s//<C-R><C-W>/g<home><right><right><right>


" todo comments mappings
map <Leader>td $a /// @todo<Esc>
map <Leader>te othrow Common::Error(LINE_TAG, 42); /// @todo<Esc>


" shortcuts for editing
map ; :
map <Leader>BD :Bdelete<Enter>
map <Leader>Bd :Bdelete<Enter>
map <Leader>bd :bd<Enter>
map <Leader>e :e<Enter>
map <Leader>w :w<Enter>


" reset editing state
map <Leader><Esc> :nohlsearch<CR>:set buftype=""<CR>:cclose<CR>


" disable keyword lookup
map K <Nop>


" for c++
set cinoptions+=g0  " for public/private indent
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


" plugins maps
map <C-p> :BufSurfBack<CR>
map <C-n> :BufSurfForward<CR>

map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

map <Leader>t :TagbarToggle<Enter>

map <C-\> :cclose<CR>:GtagsCursor<CR>
map <Leader><Leader>r :cclose<CR>:Gtags -r<SPACE>
map <Leader><Leader>d :cclose<CR>:Gtags -d<SPACE>
map <Leader>q :cclose<CR>
map - "+
map _ "+
map + "+


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
autocmd BufEnter *.h let b:fswitchdst = 'cpp,c,cc' | let b:fswitchlocs = '.,..,impl,../impl,src,../src,../source'


" Acronis localization files
autocmd BufEnter text.h let b:fullswitchdst = 'english.txt'
autocmd BufEnter english.txt let b:fullswitchdst = 'text.h'

" Switch that support Acronis files
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

" yankstack
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>n <Plug>yankstack_substitute_newer_paste


" new file skeletons
autocmd BufNewFile *.cpp 0r ~/.config/nvim/skel/cpp.skel
autocmd BufNewFile *.h 0r ~/.config/nvim/skel/h.skel
autocmd BufNewFile *.ion 0r ~/.config/nvim/skel/ion.skel
autocmd BufNewFile *.xidl 0r ~/.config/nvim/skel/xidl.skel


" deoplete
set completeopt-=preview " no annoying scratch preview
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ deoplete#mappings#manual_complete()

inoremap <silent><expr> <S-TAB>
  \ pumvisible() ? "\<C-p>" : "\<S-TAB>"


" Neomake
autocmd! BufWritePost * Neomake
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {'exe' : 'clang++' }
" Compilation flags placed in local vimrc for each project separately


" localvimrc
let g:localvimrc_ask = 0 " don't ask confirmation for local vimrc loading


" Auto file encoding detection. Used hacked enca, that show ucs-2le instead just usc-2
let g:autofenc_ext_prog_path='enca_vim.sh'
let g:autofenc_ext_prog_args=''


" format buffer with clang
map <C-K> :pyf /usr/share/clang/clang-format.py<CR>
imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<CR>


" format json buffer or selection
nmap <Leader>fj :.,$!python -m json.tool<CR>
vmap <Leader>fj :%!python -m json.tool<CR>


" copy current path
nmap cp :let @a = expand("%:p")<CR>:let @+ = expand("%:p")<CR>:let @" = expand("%:p")<CR>


" setup for Acronis project
function! InitAcronisProject()
  let l:path = findfile('family.xml', '.;')
  if (empty(l:path))
    echo "Project file not found"
  else
    let l:path = fnamemodify(l:path, ":p:h")
    let g:project_path = l:path
    execute ':abbreviate PRJ ' . g:project_path
    execute ':set path=' . '.,' . l:path . ',' . l:path . '/include,' . l:path . '/text,' . l:path . '/ext/include,' . l:path . '/core,' . l:path . '/core/include'
  endif
endfunction


" fzf
command! Locate call fzf#run(
      \ {'source': 'locate -d ' . g:project_path . '/files.db "*"', 'sink': 'e', 'window': 'new'})


function! LocateInAcronisProject()
  " init project path before search
  if !exists('g:project_path')
    call InitAcronisProject()
  endif
  execute ':Locate'
endfunction

map <Leader><Leader>p :call LocateInAcronisProject()<CR>
