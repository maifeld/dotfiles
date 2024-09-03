" don't beep, flash the screen window
set visualbell

" PRINTING
" print to kprinter and select from there
"set printexpr=system('okular'\ .\ '\ '\ .\ v:fname_in)\ .\ delete(v:fname_in)\ +\ v:shell_error
set printoptions+=paper:letter,syntax:y,wrap:y
" Print Header options are the same as Statusline options
" The general format for a code in a status line is shown in :help statusline:
" %-0{minwid}.{maxwid}{item}
" Everything except the % and the item is optional.
set printheader=%<		" Left side
set printheader+=%{strftime('%Y-%b-%d\ %H:%M')}		" add date (17 chars)
set printheader+=\ \ %.60F		" full path truncated to rightmost X characters
set printheader+=%=		" switch to right side
set printheader+=Page\ %N" (6+ chars)
set printexpr=PrintFile(v:fname_in)
function PrintFile(fname)
	call system("okular " . a:fname)
	call delete(a:fname)
	return v:shell_error
endfunc

filetype plugin on
filetype indent on

" TABBING
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

set listchars=trail:·,precedes:«,extends:»,eol:↲,tab:▸\ ,nbsp:☠
" ASCII-only
" set listchars=tab:>-,trail:~,extends:>,precedes:<
" set list listchars=tab:▸␣,trail:·
" set listchars=eol:·,nbsp:☠,tab:→\ ,trail:☠,extends:>,precedes:<
set list

" https://alvinalexander.com/linux/vi-vim-editor-color-scheme-syntax
" Highlight special characters:
" The listchars option uses the "NonText" highlighting group for "eol", "extends" and "precedes", and the "SpecialKey" highlighting group for "nbsp", "tab" and "trail"
function! MyHighlights() abort
	highlight Visual		cterm=NONE ctermbg=76  ctermfg=16  gui=NONE guibg=#5fd700 guifg=#000000
	highlight StatusLine	cterm=NONE ctermbg=231 ctermfg=160 gui=NONE guibg=#ffffff guifg=#d70000
	highlight Normal		cterm=NONE ctermbg=0               gui=NONE guibg=Black
	highlight NonText		cterm=NONE ctermbg=0               gui=NONE guibg=#111111 guifg=#222222
	highlight SpecialKey	cterm=NONE ctermbg=0               gui=NONE guibg=#111111 guifg=#222222
	highlight Comment		ctermbg=DarkGray
	highlight Constant		ctermbg=Blue
	highlight Special		ctermbg=DarkMagenta
	highlight Cursor		ctermbg=Green
	highlight ExtraWhitespace ctermbg=red guibg=red
	highlight RedundantSpaces term=standout ctermbg=Grey guibg=#ffddcc
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

" Handle whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Highlight redundant spaces (spaces at the end of the line, spaces before or after tabs):
highlight RedundantSpaces term=standout ctermbg=Grey guibg=#ffddcc
call matchadd('RedundantSpaces', '\(\s\+$\| \+\ze\t\|\t\zs \+\)\(\%#\)\@!')

" My favorite colors
"colorscheme pablo
colorscheme jellybeans

" to look at colors, use:
" :help colortest.vim

" turn on syntax highlighting always
syntax on

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

