" set leader
let mapleader = ","

" gui settings
if has("gui_running")
    set guioptions=
    set guifont=Menlo:h14
    set linespace=8

    " nerdtree
    let g:NERDTreeWinSize = 48
    nmap <Leader>d :NERDTreeToggle<CR>
    nmap <Leader>f :NERDTreeFind<CR>

    " skip colorscheme
    let macvim_skip_colorscheme = 1
    colorscheme wes

    " color after column
    let &colorcolumn=join(range(120,999),",")

    " bbye
    set runtimepath^=~/.vim/bundle/bbye
    nmap <Leader>q :Bdelete!<CR>
    nmap <Leader><Leader>q :bufdo Bdelete!<CR>

    " ctrlp
    set runtimepath^=~/.vim/bundle/ctrlp.vim
    function! CtrlP_Main(...)
        let line = '%#Normal#  Finding %*'
        let line .= '%#Function#'.a:5.'%*'
        let line .= '%#LineNr#^f%*'
        let line .= '%#Normal# by %*'
        let line .= '%#Function#'.a:2.'name%*'
        let line .= '%#LineNr#^d%*'
        let line .= '%#Normal# using %*'
        let line .= '%#Function#'
        let line .= a:3 ? 'regex' : 'fuzzy'
        let line .= '%*'
        let line .= '%#LineNr#^r%*'
        let line .= '%#Normal# matching %*'
        let line .= '%=%<%#LineNr# '.getcwd().' %*'
        return line
    endfunction

    function! CtrlP_Prog(...)
        let line = '%#Function# '.a:1.' %*'
        let line .= '%=%<%#LineNr# '.getcwd().' %*'
        return line
    endfunction

    let g:ctrlp_status_func = {'main': 'CtrlP_Main', 'prog': 'CtrlP_Prog'}
endif

" settings
set incsearch
set ignorecase
set hidden
set autoindent
set nowrap
set number
set list
set expandtab
set listchars=tab:>-
set softtabstop=4
set tabstop=4
set shiftwidth=4
set laststatus=2
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set fillchars=vert:\ 

" backup and swap files
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//

" shortcuts
nmap <Leader>w :w<CR>
nmap <Leader>3 :b#<CR>

" ctrl+t is uncomfortable for me
imap <C-f> <C-t>

" line shifting
vnoremap <S-j> xp`[V`]
vnoremap <S-k> xkP`[V`]

" repeat action in visual mode
vnoremap . :normal .<CR>

" window switching
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" buffer switching
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" trailing whitespace color
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" No bells
set visualbell t_vb= 

" syntax hell
function! SyntaxHell()
    let last_line_num = line("$")

    " Don't bother for enormous files
    if last_line_num > 50000
        return
    endif

    " Disable syntax entirely if any lines are super long
    let i = 1
    while i <= last_line_num
        if strlen(getline(i)) > &synmaxcol
            echo "Welcome to hell"
            syntax clear
            return
        endif
        let i += 1
    endwhile
endfunction

augroup commands
    au!

    " highlight trailing whitespace
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    " use tabs for these
    autocmd FileType make setlocal noexpandtab
    "autocmd FileType html setlocal noexpandtab
    "autocmd FileType css setlocal noexpandtab
    "autocmd FileType scss setlocal noexpandtab
    "autocmd FileType javascript setlocal noexpandtab

    " source .vimrc after write
    autocmd! bufwritepost .vimrc source %
    autocmd BufReadPost * call SyntaxHell()
augroup end
