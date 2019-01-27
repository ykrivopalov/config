" reset all autocommands (for safe vimrc reloading)
autocmd!

set nocompatible  " Use Vim settings, rather than Vi settings


" vim-plug pluggins
call plug#begin('~/.config/nvim/plugged')
Plug 'IN3D/vim-raml'  " syntax and language settings for RAML
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " keyword completion
Plug 'bkad/CamelCaseMotion'  " motion through CamelCaseWords
Plug 'davidhalter/jedi-vim'
Plug 'derekwyatt/vim-fswitch'  " switching between header and source
Plug 'dkasak/gruvbox'  " color scheme (it's fork with better haskell support)
Plug 'embear/vim-localvimrc'  " .localvimrc support
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'tag': '*' }  " Go development plugin for Vim
Plug 'jsfaint/gen_tags.vim'  " async plugin to ease the use of ctags/gtags
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }  " fuzzy file finder
Plug 'justinmk/vim-dirvish'  " directory viewer
Plug 'lyokha/vim-xkbswitch'  " automatic keyboard layout switching in insert mode
Plug 'maxbrunsfeld/vim-yankstack'  " cached ring of yanks
Plug 'mhinz/vim-grepper'  " helps you win at grep
Plug 'moll/vim-bbye'  " delete buffers without closing windows
Plug 'neomake/neomake'  " asynchronous linting and make
Plug 'neovimhaskell/haskell-vim'  " haskell syntax highlighting
Plug 'racer-rust/vim-racer'  " allows vim to use Racer for Rust code completion and navigation
Plug 'rust-lang/rust.vim'  " rust file detection, syntax highlighting, formatting
Plug 's3rvac/AutoFenc'  " automatically detect and set file encoding when opening a file.
Plug 'simeji/winresizer'  " easy resizing of vim windows
Plug 'ton/vim-bufsurf'  " surfing through buffers based on viewing history
Plug 'tpope/vim-commentary'  " comment stuff out
Plug 'tpope/vim-rsi'  " readline key bindings
Plug 'tpope/vim-eunuch'  " sugar for the UNIX shell commands
Plug 'vim-scripts/vcscommand.vim'  " VCS integration
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
set backspace=start,indent,eol  " backspacing over start of insert, autoindent, line breaks
set hidden  " don't unload abandoned buffers
set hlsearch  " higlight all search matches
set incsearch  " show matches while typing
set tags=tags;  " show tags upward from current dir
set wildmenu  " autocomplete in command mode
set wildmode=longest,list,full


" disable automatically insertion of comments after Enter and o/O
" autocmd is needed to override filetype plugins
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro


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

" toggles the 'paste' option, for pasting in Insert mode
set pastetoggle=<Leader>i

" substitution mappings
map <Leader>ss :%s/
map <Leader>sf :.,$s/<C-R><C-W>//gc<left><left><left>
map <Leader>sF :.,$s//<C-R><C-W>/gc<home><right><right><right><right><right>
map <Leader>sw :%s/<C-R><C-W>//g<left><left>
map <Leader>sW :%s//<C-R><C-W>/g<home><right><right><right>


" todo comments mappings
map <Leader>td $a /// @todo<Esc>
map <Leader>te othrow Common::Error(LINE_TAG, 42); /// @todo<Esc>


" common shortcuts
map ; :
map <Leader>BD :Bdelete<Enter>
map <Leader>Bd :Bdelete<Enter>
map <Leader>bd :bd<Enter>
map <Leader>e :e<Enter>
map <Leader>w :w<Enter>
map ,e :e %:p:h/
map ,w :w %:p:h/


" vertical splitting creates new panel on the right
nnoremap <C-w>v :botright vsplit<CR>
cabbrev h vert bo h


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
let g:jedi#goto_command = "<C-]>"

" for go
autocmd BufEnter *.{go} setlocal shiftwidth=4
autocmd BufEnter *.{go} setlocal noexpandtab
autocmd BufEnter *.{go} setlocal softtabstop=0
autocmd BufEnter *.{go} setlocal tabstop=4
autocmd FileType go nmap <leader>gd <Plug>(go-doc)
autocmd FileType go nmap <leader>gi <Plug>(go-implements)
autocmd FileType go nmap <leader>gc <Plug>(go-callers)

" for rust
autocmd FileType rust nmap gd <Plug>(rust-def)
autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
let g:rustfmt_autosave = 1

" for markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" for raml
autocmd BufEnter *.raml setlocal foldmethod=indent


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


" gtags helpers
let g:gen_tags#gtags_auto_update = 0
let $GTAGSFORCECPP = ""
set cscopequickfix=c-,g-,s-  " use quickfix window for csope
map <Leader><Leader>d :cscope find g<Space>
map <Leader><Leader>r :cscope find c<Space>
map <Leader>ln :lnext<CR>
map <Leader>lp :lprevious<CR>
map <Leader>q :cwindow<CR>


" for easier copy-pasting
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

" go tests
autocmd BufEnter *.go let b:fswitchdst = 'go' | let b:fswitchlocs = '.' | let b:fswitchfnames = '/$/_test/'
autocmd BufEnter *_test.go let b:fswitchdst = 'go' | let b:fswitchlocs = '.' | let b:fswitchfnames = '/_test$//'

nmap <Leader>h :FSHere<CR>


" disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" don't hide c headers
set suffixes-=.h

" xkbswitch
let g:XkbSwitchEnabled = 1

" yankstack
nmap <Leader>p <Plug>yankstack_substitute_older_paste
nmap <Leader>n <Plug>yankstack_substitute_newer_paste


" vim-grepper
let g:grepper = {}
let g:grepper.dir = 'file'
nmap <Leader><Leader>g :GrepperRg<Space>

" deoplete
set completeopt-=preview " no annoying scratch preview
autocmd BufEnter *.{cpp,h,go,py,raml,json,vim} call deoplete#enable()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" : "\<TAB>"

inoremap <silent><expr> <S-TAB>
  \ pumvisible() ? "\<C-p>" : "\<S-TAB>"


" Neomake
autocmd! BufWritePost * Neomake
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {'exe' : 'clang++' }
let g:neomake_cpp_clang_args = ['-std=c++14', '-fsyntax-only']

let g:neomake_python_enabled_makers = ['pylint']
let g:neomake_python_pylint_maker = {
  \ 'args': [
  \ '-f', 'text',
  \ '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
  \ '-r', 'n'
  \ ]
  \ }
" Compilation flags placed in local vimrc for each project separately

let g:neomake_go_enabled_makers = ['go']

" localvimrc
let g:localvimrc_ask = 0 " don't ask confirmation for local vimrc loading


" Auto file encoding detection. Used hacked enca, that show ucs-2le instead just usc-2
let g:autofenc_ext_prog_path='enca_vim.sh'
let g:autofenc_ext_prog_args=''


" format buffer or selection
nmap <Leader>fc :%py3file /usr/share/clang/clang-format.py<CR>
vmap <Leader>fc :py3file /usr/share/clang/clang-format.py<CR>
nmap <Leader>fj :%!python -m json.tool<CR>
vmap <Leader>fj :!python -m json.tool<CR>
nmap <Leader>fp :%!autopep8 -a -<CR>
vmap <Leader>fp :!autopep8 -a -<CR>
nmap <Leader>fx :%!xmllint --format -<CR>
vmap <Leader>fx :!xmllint --format -<CR>


" copy current path
nmap cp :let @a = expand("%:p")<CR>:let @+ = expand("%:p")<CR>:let @" = expand("%:p")<CR>


" fzf
command! LocateInFilesDB call fzf#run(
      \ {'source': 'locate -d ' . 'files.db "*"', 'sink': 'e', 'window': 'new'})


" vim-dirvish
augroup dirvish_config
  autocmd!
  autocmd FileType dirvish silent! unmap <buffer> <C-n>
  autocmd FileType dirvish silent! unmap <buffer> <C-p>
augroup END

command! Explore Dirvish %:p:h


function! LocateImpl()
  if filereadable('files.db')
    execute ':LocateInFilesDB'
  else
    execute 'FZF'
  endif
endfunction

map <Leader><Leader>p :call LocateImpl()<CR>

map <F1> <Esc>
imap <F1> <Esc>
