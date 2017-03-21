" don't beep, flash the screen window
set visualbell

" print to kprinter and select from there
set printexpr=system('okular'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error

filetype plugin on
filetype indent on


set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set smartindent

set nowrapscan
set ignorecase

set ai                  " always set autoindenting on
set nobk              " don't keep a backup file

" when linewrap is off, get a horizontal scrollbar
" r = right
" b = bottom
" h = limit horiz scroll size to cursor line size
" g = gray out inactive menu items (otherwise not shown at all)
" m = menubar: File, Edit, Tools
" T = toolbar: icons
set guioptions=rbmhgT
set columns=80 lines=50

" want word wrapping, but only want line breaks inserted when explicitly press the Enter key:
"set wrap " word wrap visually (as opposed to changing the text in the buffer)
"set linebreak " only wrap at a character in the breakat option (by default, this includes " ^I!@*-+;:,./?" (note the inclusion of " " and that ^I is the control character for Tab)).
"set nolist  " list disables linebreak

" prevent Vim from automatically inserting line breaks in newly entered text. The easiest way to do this is:
set textwidth=0
set wrapmargin=0

" keep your existing 'textwidth' settings for most lines in your file, but not have Vim automatically reformat when typing on existing lines
set formatoptions+=l


" My favorite colors
"colorscheme pablo
colorscheme jellybeans

" to look at colors, use:
" :help colortest.vim

" Handle whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" set listchars=tab:>-,trail:~,extends:>,precedes:<
" set list listchars=tab:▸␣,trail:·
set listchars=eol:·,nbsp:☠,tab:→\ ,trail:☠,extends:>,precedes:<
set list

" Highlight special characters:
" The listchars option uses the "NonText" highlighting group for "eol", "extends" and "precedes", and the "SpecialKey" highlighting group for "nbsp", "tab" and "trail"
highlight SpecialKey ctermfg=darkgray guifg=darkgray
highlight NonText ctermfg=darkgray guifg=darkgray


" Highlight redundant spaces (spaces at the end of the line, spaces before or after tabs):
highlight RedundantSpaces term=standout ctermbg=Grey guibg=#ffddcc
call matchadd('RedundantSpaces', '\(\s\+$\| \+\ze\t\|\t\zs \+\)\(\%#\)\@!')

" Min num of lines to scroll horizontally
"set sidescroll 1

" Number of lines to keep between the cursor and the edge of the window
"set scrolloff 999
"


set diffexpr=MyDiff()
function MyDiff()
   let opt = ""
   if &diffopt =~ "icase"
	 let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
	 let opt = opt . "-b "
   endif
   silent execute '!"/usr/bin/diff" -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
endfunction

" Try to make it also do: ]c to next change
function! DiffTake(dir, oppdir)
    let l:old = winnr()
    exec "wincmd ".a:dir
    " Assumption: just 2 windows side by side.
    if (winnr() == l:old)
        diffput
        exec "wincmd ".a:oppdir
    else
        wincmd p
        diffget
    endif
endfunction

function! SetupDiffMappings()
    if &diff
        map <Esc>, :call DiffTake("h", "l")<CR>
        map <Esc>. :call DiffTake("l", "h")<CR>
    endif
endfunction

" vim -d
call SetupDiffMappings()
" Entering diff mode from within vim - diffsplit, etc.
autocmd FilterWritePost * call SetupDiffMappings()


" With the following you can visually select text
" then press ~ to convert the text to UPPER CASE, then to lower case, then to
" Title Case. Keep pressing ~ until you get the case you want.
" also:
"        :s/\<\(\w\)\(\S*\)/\u\1\L\2/g
"
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv
