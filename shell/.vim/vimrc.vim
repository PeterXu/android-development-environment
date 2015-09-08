" Set map leader
let mapleader = ":"
let g:mapleader = ":"


" -------------------------
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


" --------------------------------------
" load tags from both current and system
if filereadable(".tags")
  set tag+=.tags
elseif filereadable(".xtags/tags")
  set tag+=.xtags/tags
endif
if filereadable(glob("$HOME/.xtags/tags"))
  set tag+=${HOME}/.xtags/tags
endif


" ---------
" tab/space
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab " use spaces to expandtab, else <set noexpandtab>


" ----------------
" licenses setting
map <leader>mit :0r ~/.vim/licenses/mit.txt
map <leader>bsd2 :0r ~/.vim/licenses/bsd2.txt
map <leader>bsd3 :0r ~/.vim/licenses/bsd3.txt
"autocmd BufNewFile *
"    :0r ~/.vim/licenses/mit.txt
"augroup END


" --------------------------
" Linebreak on 500 characters
"set lbr
"set tw=500
"set autoread       " Set to auto read when a file is changed from the outside
"set wrap           " wrap lines
"set si             " smart indent
"set laststatus=2   " Always show the status line


" --------------
" spell checking
map <leader>ss :setlocal spell!


" ---------------------------------
" Useful mappings for managing tabs
map <leader>tn :tabnew
map <leader>to :tabonly
map <leader>tc :tabclose
map <leader>tm :tabmove


" ------------
" For markdown
let g:vim_markdown_folding_disabled=1


" ------------------------------------------
" Insert date: YYYY-MM-DD
map <leader>dt a<C-R>=strftime('%Y-%m-%d')<CR>


" ------------------------------
" Insert development author info
let _author = "peter@uskee.org"
map <leader>aush <Home>i<C-R>= 
    \ ""
    \ . "# Author: " . _author . "\n"
    \ . "# Created: " . strftime('%Y-%m-%d') . "\n"
    \ . "#\n" <CR>
map <leader>aupy <Home>i<C-R>= 
    \ ""
    \ . "# coding: utf-8\n"
    \ . "# Author: " . _author . "\n"
    \ . "# Created: " . strftime('%Y-%m-%d') . "\n"
    \ . "#\n" <CR>
map <leader>aucc <Home>i<C-R>= 
    \ ""
    \ . "/**\n"
    \ . "Author: " . _author . "\n"
    \ . "Created: " . strftime('%Y-%m-%d') . "\n"
    \ . "/\n" <CR>



" -----------------------------
" custom functions and commands
func! Usage(arg)
    echo "\n[Usage]: \n" 
    if a:arg == "map" || a:arg == ""
        echo ""
            \ . "  <S-:> + ss:  spell checking\n"
            \ . "  <S-:> + dt:  insert date, YYYY-MM-DD\n" 
            \ . "  <S-:> + tn/to/tc/tm:  tabnew/tabonly/tabclose/tabmove\n" 
            \ . "  <S-:> + aush/aupy/aucc:  insert author info for shell/python/c-c++\n"
            \ . "  <S-:> + mit/bsd2/bsd3:  insert one license\n"
    endif
    echo
endfunc

command! -nargs=* Help call Usage('<args>')

