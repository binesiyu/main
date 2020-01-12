" basic {
set nocompatible " be iMproved, required

function! OSX()
    return has('macunix')
endfunction
function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

" }

" language and encoding setup {

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    if !has("gui_vimr")
        silent exec 'language en_US'
    end
else
    let s:uname = system("uname -s")
    if s:uname == "Darwin\n"
        " in mac-terminal
        silent exec 'language en_US'
    else
        " in linux-terminal
        silent exec 'language en_US.utf8'
    endif
endif

if !has('nvim')
    if OSX()
        set pythondll=''
    endif
endif

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if WINDOWS()
    " Be nice and check for multi_byte even if the config requires
    " multi_byte support most of the time
    if has('multi_byte')
        " Windows cmd.exe still uses cp850. If Windows ever moved to
        " Powershell as the primary terminal, this would be utf-8
        set termencoding=cp850
        " Let Vim use utf-8 internally, because many scripts require this
        set encoding=utf-8
        setglobal fileencoding=utf-8
        " Windows has traditionally used cp1252, so it's probably wise to
        " fallback into cp1252 instead of eg. iso-8859-15.
        " Newer Windows files might contain utf-8 or utf-16 LE so we might
        " want to try them first.
        set fileencodings=ucs-bom,utf-8,gbk,gb2312,big5,iso-8859-15,utf-16le
    endif
    if !exists('g:exvim_custom_path')
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    else
        let g:ex_tools_path = g:exvim_custom_path.'/vimfiles/tools/'
        let g:ex_dein_path = g:exvim_custom_path.'/vimfiles/dein'
        exec 'set rtp+=' . fnameescape ( g:exvim_custom_path.'/vimfiles/dein/repos/github.com/Shougo/dein.vim/' )
    endif
else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8

    let g:ex_tools_path = '~/.vim/tools/'
    let g:ex_dein_path = '~/.vim/dein/'
    set rtp+=~/.vim/dein/repos/github.com/Shougo/dein.vim

    if has('multi_byte')
        set fileencodings=ucs-bom,utf-8,gbk,gb2312,big5,iso-8859-15,utf-16le
    endif
endif

scriptencoding utf-8

let mapleader = ','
let maplocalleader=mapleader
" }

" Bundle steup {

filetype off " required


" Plugin Commands
com! -nargs=+  -bar   Plugin call dein#add(<args>)
" PluginInstall
com! -nargs=* -bang  PluginInstall call dein#install()
" PluginUpdate
com! -nargs=* -bang  PluginUpdate call dein#update()
" PluginReCache
com! -nargs=* -bang  PluginReCache call dein#recache_runtimepath()

" matchit
source $VIMRUNTIME/macros/matchit.vim

if dein#load_state(g:ex_dein_path)
call dein#begin(g:ex_dein_path)
" call dein#add('Shougo/dein.vim')
Plugin 'Shougo/dein.vim'
Plugin 'Shougo/vimproc'

" textobj
Plugin 'kana/vim-textobj-user'
"ai/ii
Plugin 'kana/vim-textobj-indent'
"ae/ie
Plugin 'kana/vim-textobj-entire'
"al/il
Plugin 'kana/vim-textobj-line'
"af/if/aF/iF
Plugin 'kana/vim-textobj-function'
"a,/i,
Plugin 'sgur/vim-textobj-parameter'
"av/iv
Plugin 'Julian/vim-textobj-variable-segment'
"ac/ic/aC/iC
Plugin 'coderifous/textobj-word-column.vim'
"ab/ib
Plugin 'rhysd/vim-textobj-anyblock'
Plugin 'binesiyu/vim-textobj-function-syntax'
Plugin 'binesiyu/vim-textobj-lua'

" operator
Plugin 'kana/vim-operator-user'
Plugin 'kana/vim-operator-replace'
Plugin 'syngan/vim-operator-furround'
Plugin 'thinca/vim-operator-sequence'

Plugin 'tpope/vim-repeat'

call dein#end()
call dein#save_state()
endif

filetype plugin indent on " required
" }

" General {

" backup swap {{
"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set notimeout
set nobackup " make backup file and leave it around
set noswf "
" set acd "autochchdir
" }}

" history {{
" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)
" }}


" Text edit {{
set showfulltag " show tag with function protype.
set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

set sessionoptions -=folds

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
" }}

" Fold text {{
set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999
" }}

" Search {{
set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m
" }}

" window op {{
set listchars=tab:›\ ,trail:•,extends:↷,precedes:↶,nbsp:. " Highlight problematic whitespace
set noerrorbells visualbell t_vb=
set fillchars=vert:│,fold:·
set nrformats-=octal
"}}

" clipboard {{
set splitbelow
" define the copy/paste judged by clipboard
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamedplus,unnamed
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
"}}
" }

" Auto Command {
if has('autocmd')
    augroup ex
        au!
        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"

        if has("gui_vimr")
            au FocusGained * checktime
        end
    augroup END
endif
" }

" Key Mappings {

" Don't use Ex mode, use Q for formatting
" map Q gq
map Q =

" change ; to :
noremap ; :
vnoremap ; :
" Swap implementations of ` and ' jump to markers
nnoremap ' `
nnoremap ` '

" copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
nnoremap <silent> <leader>y1 :let @*=fnamemodify(bufname('%'),":p:h")<CR>

" copy file name to clipboard, foo/bar/foobar.c => foobar.c
nnoremap <silent> <leader>y2 :let @*=fnamemodify(bufname('%'),":p:t")<CR>

" copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
nnoremap <silent> <leader>y3 :let @*=fnamemodify(bufname('%'),":p")<CR>

" map Ctrl-Tab to switch window
nnoremap <leader>wk <C-W><Up>
nnoremap <leader>wj <C-W><Down>
nnoremap <leader>wh <C-W><Left>
nnoremap <leader>wl <C-W><Right>
nnoremap <leader>wm <C-W>_

" noremap <C-c> <Esc>

"When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

map <Leader>p ]p
map <Leader>P ]P

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_
" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
            \ 'zt' : (winline() == &scrolloff + 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
            \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "H")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
            \ ."\<C-u>".(line('w0') <= 1 ? "H" : "L")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "4\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "4\<C-y>")

nmap <Space> <C-e>
nmap <S-Space> <C-y>

" Visual-mode swapping
vnoremap <C-W> <Esc>`.``gvP``P
" nnoremap <leader>d "_

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj
" Go to home and end using capitalized directions
" noremap J L
" noremap K H
" noremap H ^
" noremap L $
"j/k to jumplist
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
noremap <Leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
noremap <Leader>bl :buffers<CR>:let nr = input("Which one: ")<Bar>exe "buffer " . nr<CR>

" nnoremap <leader>r :%s#\<<C-r>=expand("<cword>")<CR>\>#
" Make Y consistent with D
nnoremap Y y$

noremap! <F1> <Esc>
imap <F1> <C-o>:echo<CR>
inoremap <c-c> <c-[>
noremap <F2> :set wrap!<BAR>set wrap?<CR>
" noremap <F4> :set ignorecase!<BAR>set ignorecase?<CR>
noremap <F4> :set relativenumber!<BAR>set relativenumber?<CR>
" F8 or <leader>/:  Set Search pattern highlight on/off
noremap <F11> :set cursorline!<BAR>set nocursorline?<CR>
noremap <F12> :set cursorcolumn!<BAR>set nocursorcolumn?<CR>

function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>n :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>h :<C-u>call VisualSelection()<CR>:set hls<CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
vnoremap <silent> <leader>N :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
nnoremap <leader>h :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nmap <leader>n *
nmap <leader>N #
nnoremap <F8> :let @/=""<CR>
nnoremap <leader>/ :let @/=""<CR>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap w!! %!sudo tee > /dev/null %

" nnoremap v V
" vnoremap v V
" nnoremap V v
" vnoremap V v

" nnoremap <c-]> g<c-]>
" vnoremap <c-]> g<c-]>
" nnoremap g<c-]> <c-]>
" vnoremap g<c-]> <c-]>

" Fast saving
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>
" Visually select the text that was last edited/pasted
noremap gV `[v`]
"}

" plug-config  {

" textobj {
map <silent>gsa <Plug>(operator-furround-append-input)
map <silent>gss <Plug>(operator-furround-append-input)
map <silent>gsd <Plug>(operator-furround-delete)
map <silent>gsr <Plug>(operator-furround-replace-input)


" delete or replace most inner furround
" if you use vim-textobj-anyblock
nmap <silent>gsdd <Plug>(operator-furround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>gsrr <Plug>(operator-furround-replace-input)<Plug>(textobj-anyblock-a)

map <silent>gr <Plug>(operator-replace)
nmap <expr>grr '<Plug>(operator-replace)iw'
nmap <expr>grb '<Plug>(operator-replace)ib'
nmap <expr> <Leader>gd operator#sequence#map('y', [',ge'])

map <silent>gdd <Plug>(operator-luadump)
nmap <expr>gddd '<Plug>(operator-luadump)iw'
map <silent>gdD <Plug>(operator-luadumpbefore)
nmap <expr>gdDD '<Plug>(operator-luadumpbefore)iw'
map <silent>gdp <Plug>(operator-luaprint)
nmap <expr>gdpp '<Plug>(operator-luaprint)iw'
map <silent>gdP <Plug>(operator-luaprintbefore)
nmap <expr>gdPP '<Plug>(operator-luaprintbefore)iw'
" }


noremap <Leader>a& :Tabularize /&<CR>
vnoremap <Leader>a& :Tabularize /&<CR>
noremap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
vnoremap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
noremap <Leader>a=> :Tabularize /=><CR>
vnoremap <Leader>a=> :Tabularize /=><CR>
noremap <Leader>a: :Tabularize /:<CR>
vnoremap <Leader>a: :Tabularize /:<CR>
noremap <Leader>a:: :Tabularize /:\zs<CR>
vnoremap <Leader>a:: :Tabularize /:\zs<CR>
noremap <Leader>a, :Tabularize /,<CR>
vnoremap <Leader>a, :Tabularize /,<CR>
noremap <Leader>a,, :Tabularize /,\zs<CR>
vnoremap <Leader>a,, :Tabularize /,\zs<CR>
noremap <Leader>a<Bar> :Tabularize /<Bar><CR>
vnoremap <Leader>a<Bar> :Tabularize /<Bar><CR>
nnoremap <silent> <leader>= :call g:Tabular(1)<CR>
xnoremap <silent> <leader>= :call g:Tabular(0)<CR>
function! g:Tabular(ignore_range) range
    let c = getchar()
    let c = nr2char(c)
    if a:ignore_range == 0
        exec printf('%d,%dTabularize /%s', a:firstline, a:lastline, c)
    else
        exec printf('Tabularize /%s', c)
    endif
endfunction

let g:tcomment_mapleader1=''
let g:tcomment_mapleader2=''
" the default (g<) is a bit awkward to type
let g:tcomment_mapleader_uncomment_anyway=''
let g:tcomment_mapleader_comment_anyway='gC'
let g:tcomment_textobject_inlinecomment=''
map <Leader>cl <Plug>TComment_gcc
map <Leader>ci <Plug>TComment_gcc
map <Leader>c<Space> <Plug>TComment_gcc

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

function! TabMessage(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    " use "new" instead of "tabnew" below if you prefer split windows instead of tabs
    tabnew
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command TabMessage call TabMessage(<q-args>)


" register / {
function! MakePattern(text)
  let pat = escape(a:text, '\')
  let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
  let pat = substitute(pat, '^\_s\+', '\\s\\*', '')
  let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
vnoremap <silent> <F3> :<C-U>let @/="<C-R>=MakePattern(@*)<CR>"<CR>:set hls<CR>
nnoremap <F3> :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

function! Del_word_delims()
   let reg = getreg('/')
   " After *                i^r/ will give me pattern instead of \<pattern\>
   let res = substitute(reg, '^\\<\(.*\)\\>$', '\1', '' )
   if res != reg
      return res
   endif
   " After * on a selection i^r/ will give me pattern instead of \Vpattern
   let res = substitute(reg, '^\\V'          , ''  , '' )
   let res = substitute(res, '\\\\'          , '\\', 'g')
   let res = substitute(res, '\\n'           , '\n', 'g')
   return res
endfunction

inoremap <silent> <C-R>/ <C-R>=Del_word_delims()<CR>
cnoremap          <C-R>/ <C-R>=Del_word_delims()<CR>
" }

" Strip whitespace {
function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
endfunction
" autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql,lua autocmd BufWritePre <buffer> call StripTrailingWhitespace()
nnoremap <leader>ws :call StripTrailingWhitespace()<CR>
" }

" edit vimrc {
function! ExpandFilenameAndExecute(command, file)
    execute a:command . " " . expand(a:file, ":p")
endfunction

function! EditVimrc13Config()
    call ExpandFilenameAndExecute("tabedit", "$HOME/.vimrc")
    execute bufwinnr(".vimrc") . "wincmd w"
endfunction

noremap <Leader>ev :call EditVimrc13Config()<CR>
noremap <Leader>er :source $HOME/.vimrc<CR>
noremap <Leader>es :NeoSnippetEdit<CR>
" }

" Code folding options {
noremap <leader>f0 :set foldlevel=0<CR>
" }

" nav {
nnoremap <leader>tj  :tabfirst<CR>
nnoremap <leader>th  :tabnext<CR>
nnoremap <leader>tl  :tabprev<CR>
nnoremap <leader>tk  :tablast<CR>
" nnoremap <leader>tt  :tabedit<Space>
" nnoremap <leader>tn  :tabnext<Space>
nnoremap <leader>tn  :tabnew<CR>
nnoremap <leader>tc  :tabclose<CR>
nnoremap <leader>tm  :tabm<Space>
nnoremap <leader>td  :tabclose<CR>
nnoremap H gT
nnoremap L gt
" Alternatively use
"nnoremap <leader>th :tabnext<CR>
"nnoremap <leader>tl :tabprev<CR>
"nnoremap <leader>tn :tabnew<CR>
" Switch to last-active tab
if !exists('g:Lasttab')
    let g:Lasttab = 1
    let g:Lasttab_backup = 1
endif
autocmd! TabLeave * let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()
autocmd! TabClosed * let g:Lasttab = g:Lasttab_backup
nmap <silent> <Leader>tp :exe "tabn " . g:Lasttab<cr>

for i in range(1,9)
    let s:str = i . ' ' . i
    exec 'nnoremap <leader>t'. s:str .'gt'
    exec 'nnoremap <leader>'. s:str .'<C-W>W'
    exec 'noremap <leader>f' . i  . ' :set foldlevel=' . i . '<CR>'
endfor

nnoremap <leader>if :exec 'normal ,hciw' . expand('%:t:r:r:r') . "\e"<CR>
nnoremap <leader>ip :normal "_cib*

command! OpenInVSCode exe "silent !code --goto '" . expand("%") . ":" . line(".") . ":" . col(".") . "'" | redraw!
" nnoremap <S-CR> O<Esc>j
" nnoremap <CR> o<Esc>k

" }

runtime! plugin/**/*.vim
" vim:ts=4:sw=4:sts=4 et fdm=marker:
