if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif


"set compatible
set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set nu          " show line number


" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif


" Set cscope for c/c++/java
if has("cscope") 
  "set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb

  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  elseif filereadable(".xtags/cscope.out")
    cs add .xtags/cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif

  set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running") || has("syntax")
  syntax on
  set hlsearch
endif


" Enable filetype plugins
filetype plugin on
filetype indent on

if &term=="xterm"
  set t_Co=8
  set t_Sb=[4%dm
  set t_Sf=[3%dm
endif


" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"


" ctags
if filereadable(".tags")
  set tag+=.tags
elseif filereadable(".xtags/tags")
  set tag+=.xtags/tags
  set tag+=.xtags/systags
endif


" tab/space
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab " use spaces to expandtab, else <set noexpandtab>


" Set map leader
let mapleader = ":"
let g:mapleader = ":"


" licenses setting
map <leader>mit :0r ~/.vim/licenses/mit.txt
map <leader>bsd2 :0r ~/.vim/licenses/bsd2.txt
map <leader>bsd3 :0r ~/.vim/licenses/bsd3.txt
"autocmd BufNewFile *
"    :0r ~/.vim/licenses/mit.txt
"augroup END


" Linebreak on 500 characters
"set lbr
"set tw=500
"set autoread       " Set to auto read when a file is changed from the outside
set wrap           " wrap lines
"set si             " smart indent
"set laststatus=2   " Always show the status line


" spell checking
map <leader>ss :setlocal spell!

" Useful mappings for managing tabs
map <leader>tn :tabnew
map <leader>to :tabonly
map <leader>tc :tabclose
map <leader>tm :tabmove

