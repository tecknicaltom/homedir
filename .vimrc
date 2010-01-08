"Tom Samstag's .vimrc

"==================
" Options
"==================
color darkblue "my preferred color scheme for gVim
syn on "turn on syntax hilighting
set ruler "show the current line, column in the status bar
set showmatch "briefly highlight matching brackets when one is typed
set wildmode=list:longest "tab complete only until the first ambiguity, and show list of completions
set incsearch "search incrementally, showing the result of the search as you type
set ignorecase "ignore cases in searches
set smartcase "if a cap is used in a search, use case sensitive
set cindent "use the smarter C-style indentation rules
"set cinoptions=:0,g0,+2s "sets the options for cindent:
set cinoptions=:0,g0,W0,M1,(1s "sets the options for cindent:
	" :0 case labels are aligned with the indent of the switch
	" g0 c++ scope declarations are aligned with the indent of the block they're in
	" +2s indent a continuation line 2x indentations
set scrolloff=2 "keep two lines above/below scroll area
set laststatus=2 "always display a status line
set backspace=2 "same as indent,eol,start. allow backspacing over autoindent, line breaks, and where you went into insert mode
set title "Allow Vim to set the title of the window (more for console-mode Vim than gVim)
set tabstop=4 "display tabs as 4 chars wide
set shiftwidth=4 "indent 4 chars for each autoindent
set noexpandtab "don't expand tab chars into spaces
set encoding=utf-8 "use UTF-8 by default
set fileencoding=utf-8 "use UTF-8 file encoding by default
set hlsearch "highlight all matches of the current search
set history=200 "remember 200 : commands
set mouse=a "allow the use of the mouse in all modes
set statusline=%<\ %n:%f\ %m%r%y%30.((%{CharForStatus()})%)%=%-18.(%l/%L,\ %c%V%)\ %P

" Folding
" set foldmethod=indent "indented areas automatically get folds
" set foldlevelstart=8 "start out with folds deeper than 5 folded

"Set up visual whitespace
if( matchstr( $LC_ALL, '[uU][tT][fF]' ) != '' )
	set listchars=tab:»·,trail:·
else
	set listchars=tab:>-,trail:~
endif
set list "turn on visual whitespace

"==================
" Mappings
"==================
" pressing F4 clears the current search
nmap <silent> <F4> :let @/ = ""<CR>

" pressing ,s switches between .c/.cpp and .h files (requires
" ~/.vim/plugin/switch_headers.vim)
nmap ,s :call SwitchHeader()<CR>

" pressing F7 calls :make
map <F7> :make<CR>

" pressing ,g greps for the word under the cursor
map ,g :grep <cword><CR>

" pressing ,f filters the current file for the word under the cursor
map ,f :%!grep <cword><CR> :exe 'let @/ = "'.expand('<cword>').'"'<CR>

"==================
" Allow for computer-specific settings
"==================
if (hostname() == "tomslappy")
  " Home machine
elseif (hostname() == "toms")
  " Work windows machine
elseif (hostname() == "flexo")
  " Work linux machine
endif



filetype plugin on

" Vim Tip 790 - view word documents in Vim (good for diff'ing) 
autocmd BufReadPre *.doc set ro
autocmd BufReadPost *.doc silent %!antiword "%" 

map + <c-w>+
map - <c-w>-

map <F9> :cp<CR>
map <F10> :clist<CR>
map <F11> :cc<CR>
map <F12> :cn<CR>

map <S-F9> :tp<CR>
map <S-F10> :tselect<CR>
map <S-F11> :0tn<CR>
map <S-F12> :tn<CR>

set textwidth=80

function! Hexedit()
	set winwidth=8
	only
	normal ma1GyG'a
	8vnew
	set scrollbind
	normal P
	%!hexdump -C | cut -c1-8
	wincmd l
	16vnew
	set scrollbind
	wincmd x
	wincmd l
	normal P
	%!hexdump -C | cut -c62-77
	wincmd h
	set scrollbind
	%!hexdump -C | cut -c11-58
endfunction

" Until I get something better...
nmap <F5> :call P4Checkout()<CR>
function! P4Checkout()
	if (confirm("Checkout from Perforce?", "&Yes\n&No", 1) == 1)
		let p4file = substitute( system("cygpath -wa \"" . expand("%:p") . "\""), '[\r\n]*$', '', '' )
		let p4err = system("p4 -p ".b:P4Server." -u ".b:P4User." -c ".b:P4Client." -P ".b:P4Password." edit '" . p4file . "'")
		if v:shell_error == 0
			set noreadonly
		else
			echo p4err
		endif
	endif
endfunction

nmap <F6> :call P4DiffToHead()<CR>
function! P4DiffToHead()
	let l:p4file = substitute( system("cygpath -wa \"" . expand("%:p") . "\""), '[\r\n]*$', '', '' )
	let l:tmpname = tempname()
	let l:p4tmpname = substitute( system("cygpath -wa \"" . l:tmpname . "\""), '[\r\n]*$', '', '' )
	let l:p4err = system("p4 -p ".b:P4Server." -u ".b:P4User." -c ".b:P4Client." -P ".b:P4Password." print -o '" . l:p4tmpname . "' '" . l:p4file . "'")
	exe "vert diffsplit " . l:tmpname
endfunction


set gfm+=%f:\ %l:\ %m
set grepprg=glimpsegrep\ $*
com! -nargs=* Grep let s:oldgrep = &grepprg | set grepprg=grep\ -n | grep <args> | let &grepprg = s:oldgrep


function! CsvDiff()
	let temp_in = tempname()
	let temp_new = tempname()
	silent execute "!sed 's/,.*//' " . v:fname_in . " > " . temp_in
	silent execute "!sed 's/,.*//' " . v:fname_new . " > " . temp_new
	silent execute "!diff -a --binary " . temp_in . " " . temp_new . " > " . v:fname_out
endfunction

function! Beautify()
	let l:temp = tempname()
	exe "write " . l:temp
	silent! %s,\s\+$,,
	silent! %s,\<\(\(if\)\|\(for\)\|\(switch\)\)(,\1 (,g
	normal G=1G
	exec "vertical diffsplit " . l:temp
endfunction

" Formats a string describing the character under the cursor for use in the
" status line
function! CharForStatus()
	let l:text = ''
	redi => l:text | silent ascii | redi END
	let l:text = substitute(l:text, '[\r\n]', '', 'g')
	let l:text = substitute(l:text, ',\s*Octal\s[0-7]*', '', 'g')
	let l:text = substitute(l:text, '\s*Hex\s*', '0x', 'g')
	let l:text = substitute(l:text, '>\zs\s*', ' ', 'g')
	return l:text
endfunction

