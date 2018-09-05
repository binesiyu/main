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

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if !exists('g:exvim_custom_path')
    if WINDOWS()
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
endif
" }

" language and encoding setup {

" always use English menu
" NOTE: this must before filetype off, otherwise it won't work
set langmenu=none

" use English for anaything in vim-editor.
if WINDOWS()
    silent exec 'language english'
elseif OSX()
    silent exec 'language en_US'
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

" try to set encoding to utf-8
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

else
    " set default encoding to utf-8
    set encoding=utf-8
    set termencoding=utf-8
endif
scriptencoding utf-8

let mapleader = ','
let maplocalleader=mapleader
" }

" Bundle steup {

filetype off " required

" set the runtime path to include Vundle
if exists('g:exvim_custom_path')
    let g:ex_tools_path = g:exvim_custom_path.'/vimfiles/tools/'
    let g:ex_dein_path = g:exvim_custom_path.'/vimfiles/dein'
    exec 'set rtp+=' . fnameescape ( g:exvim_custom_path.'/vimfiles/dein/repos/github.com/Shougo/dein.vim/' )
else
    let g:ex_tools_path = '~/.vim/tools/'
    let g:ex_dein_path = '~/.vim/dein/'
    set rtp+=~/.vim/dein/repos/github.com/Shougo/dein.vim
endif

" Plugin Commands
com! -nargs=+  -bar   Plugin
\ call dein#add(<args>)
" PluginInstall
com! -nargs=* -bang -complete=custom,vundle#scripts#complete PluginInstall
\ call dein#install()
" PluginUpdate
com! -nargs=* -bang -complete=custom,vundle#scripts#complete PluginUpdate
\ call dein#update()
" PluginReCache
com! -nargs=* -bang -complete=custom,vundle#scripts#complete PluginReCache
\ call dein#recache_runtimepath()

source $VIMRUNTIME/macros/matchit.vim

if dein#load_state(g:ex_dein_path)
call dein#begin(g:ex_dein_path)
" call dein#add('Shougo/dein.vim')
Plugin 'Shougo/dein.vim'

" man.vim: invoked by :Man {name}
" source $VIMRUNTIME/ftplugin/man.vim
" matchit
" Plugin 'andymass/vim-matchup'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'Shougo/vimproc'

" ui
Plugin 'mhinz/vim-startify'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'nathanaelkane/vim-indent-guides'

" textobj
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-line'
Plugin 'kana/vim-textobj-function'
Plugin 'binesiyu/vim-textobj-function-syntax'

Plugin 'gcmt/wildfire.vim'

" incsearch
Plugin 'vim-scripts/ingo-library'
Plugin 'vim-scripts/SearchHighlighting'

" ctrlp
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'jasoncodes/ctrlp-modified.vim'
Plugin 'FelikZ/ctrlp-py-matcher'

"ctrlsf
Plugin 'dyng/ctrlsf.vim',{'on': 'CtrlSF'}

" nerdtree
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'

" vim-markdown
Plugin 'plasticboy/vim-markdown'
Plugin 'iamcco/markdown-preview.vim'

" lint
Plugin 'neomake/neomake'

" autocomplete
Plugin 'Shougo/neocomplete'
" completesource
Plugin 'Shougo/neco-syntax',          { 'on_event' : 'InsertEnter'}
Plugin 'Shougo/neopairs.vim',         { 'on_event' : 'InsertEnter'}
Plugin 'Raimondi/delimitMate'

" snippet
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'

" vim-easymotion
Plugin 'binesiyu/vim-easymotion'
Plugin 'rhysd/clever-f.vim'

" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------
Plugin 'godlygeek/tabular'

" ex-showmarks: invoke by m... or <leader>mm, <leader>ma
Plugin 'exvim/ex-showmarks'

" searchcompl: invoke by /
Plugin 'exvim/searchcompl'
Plugin 'scrooloose/nerdcommenter'
" Plugin 'tpope/vim-commentary'

Plugin 'Konfekt/FastFold'
Plugin 'Konfekt/FoldText'

" undotree: invoke by <Leader>u
Plugin 'mbbill/undotree'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

Plugin 'morhetz/gruvbox'

" lua
Plugin 'binesiyu/vim-quick-community'
Plugin 'binesiyu/vim-lua-ftplugin'  " Lua file type plug-in for the Vim text editor
Plugin 'tbastos/vim-lua'
" git
Plugin 'junegunn/gv.vim',{ 'on_cmd' : ['GV']}
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'lambdalisue/gina.vim',{ 'on_cmd' : 'Gina'}

" vim-airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" haskell
Plugin 'dag/vim2hs'
" Plugin 'Twinside/vim-haskellConceal'
Plugin 'Twinside/vim-haskellFold'
Plugin 'Twinside/vim-hoogle'
Plugin 'lukerandall/haskellmode-vim'
Plugin 'eagletmt/neco-ghc'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'nbouscal/vim-stylish-haskell'

Plugin 'binesiyu/vim-winmode'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
Plugin 'moll/vim-bbye'
Plugin 'vim-scripts/BufOnly.vim'

Plugin 'binesiyu/vim-tweak'
Plugin 'binesiyu/exvim'

call dein#end()
call dein#save_state()
endif

filetype plugin indent on " required
syntax on " required
" }

" Default colorscheme setup {

if has('gui_running')
    set background=dark
else
    set background=dark
    " set t_Co=256 " make sure our terminal use 256 color
    if OSX()
        let g:solarized_termcolors = 16
    else

        let g:solarized_termcolors = 16
        " let g:solarized_termcolors = 256
    endif
    " let g:solarized_termtrans=1
endif
" colorscheme Monokai-binesiyu
if WINDOWS()
    colorscheme gruvbox
else
    colorscheme gruvbox
    " colorscheme solarized
endif
" }

" General {

" backup swap {{
"set path=.,/usr/include/*,, " where gf, ^Wf, :find will search
set notimeout
set nobackup " make backup file and leave it around
set noswf "
set acd "autochchdir
" }}

" history {{
" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)
" }}

" xterm settings {{

behave xterm  " set mouse behavior as xterm
if &term =~ 'xterm'
    set mouse=a
endif
" }}

" Variable settings ( set all ) {{

" ------------------------------------------------------------------
" Desc: Visual
" ------------------------------------------------------------------

set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set rnu " show line number
set scrolloff=7 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text
set cursorline

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" }}

" Vim UI {{

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)
" }}

" set window size (if it's GUI) {{
if has('gui_running')
    " set window's width to 130 columns and height to 40 rows
    if exists('+lines')
        set lines=40                " 40 lines of text instead of 24
    endif
    if exists('+columns')
        set columns=150
    endif

    " disable menu & toolbar
    set guioptions-=T           " Remove the toolbar
    set guioptions-=m           " Remove the menu
    set guioptions-=L           " Remove the
    set guioptions-=b           " Remove the
    set guioptions-=r           " Remove the
    set gcr=a:block-blinkon0    "noblock"

    " set guifont
    if OSX()
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
    elseif WINDOWS()
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI:qDRAFT
    else
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
    endif
endif
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
set splitbelow
set splitright
set listchars=tab:›\ ,trail:•,extends:↷,precedes:↶,nbsp:. " Highlight problematic whitespace
set noerrorbells visualbell t_vb=
set fillchars=vert:│,fold:·
set nrformats-=octal
"}}
" }

" Auto Command {

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

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

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
    augroup END
endif
" }

" Key Mappings {

" Don't use Ex mode, use Q for formatting
" map Q gq
map Q =

" define the copy/paste judged by clipboard
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif


" change ; to :
noremap ; :
vnoremap ; :

cnoremap w!! %!sudo tee > /dev/null %
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

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
nmap <Leader>bl :buffers<CR>:let nr = input("Which one: ")<Bar>exe "buffer " . nr<CR>
nnoremap <leader>ff :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nnoremap <leader>fc :GSW <C-R>*<CR>

map <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
nmap <F2> :set wrap!<BAR>set wrap?<CR>
nnoremap <F3> :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
" nmap <F4> :set ignorecase!<BAR>set ignorecase?<CR>
nmap <F4> :set relativenumber!<BAR>set relativenumber?<CR>
" F8 or <leader>/:  Set Search pattern highlight on/off
nnoremap <F8> :let @/=""<CR>
nmap <F11> :set cursorline!<BAR>set nocursorline?<CR>
nmap <F12> :set cursorcolumn!<BAR>set nocursorcolumn?<CR>
nmap <Space> <C-e>
nmap <S-Space> <C-y>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Fast saving
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>
"}

" plug-config  {

let g:vim_wildignore
      \ = '*/tmp/*,*.so,*.swp,*.zip,*.class,tags,*.jpg,
      \*.ttf,*.TTF,*.png,*/target/*,*.exvim*/*,
      \.git,.svn,.hg,.DS_Store,*.svg'

fu! Generate_ignore(ignore,tool, ...) abort
    let ignore = []
    if a:tool ==# 'ag'
        for ig in split(a:ignore,',')
            call add(ignore, '--ignore')
            call add(ignore, "'" . ig . "'")
        endfor
    elseif a:tool ==# 'rg'
        if WINDOWS()
            for ig in split(a:ignore,',')
                call add(ignore, '-g')
                if a:0 > 0
                    call add(ignore, "\"" . ig . "\"")
                else
                    call add(ignore, '!' . ig)
                endif
            endfor
        else
            for ig in split(a:ignore,',')
                call add(ignore, '-g')
                if a:0 > 0
                    call add(ignore, "'!" . ig . "'")
                    " call add(ignore, "'" . ig . "'")
                else
                    " call add(ignore, "'!" . ig . "'")
                    call add(ignore, '!' . ig)
                endif
            endfor

        endif
    endif
    return ignore
endf
"}

" ui {
let g:startify_custom_header = []
let g:startify_session_dir = $HOME .  '/.data/' . ( has('nvim') ? 'nvim' : 'vim' ) . '/session'
let g:startify_files_number = 6
let g:startify_list_order = [
      \ ['   These are my bookmarks:'],
      \ 'bookmarks',
      \ ['   My most recently used files in the current directory:'],
      \ 'dir',
      \ ['   My most recently used files:'],
      \ 'files',
      \ ]
if OSX()
    let g:startify_bookmarks = [{'c' : '~/Documents/dev/kingdom-of-heaven-client/koh.exvim'},
                \ {'k': '~/Documents/dev/kingdom-of-heaven-client/koh-c.exvim'},
                \ {'x': '~/Documents/dev/koh/koh.exvim'},
                \'~/.vimrc',
                \'~/.zshrc',
                \]
else
    let g:startify_bookmarks = [ '~/.vimrc', '~/.zshrc']
endif

let g:startify_update_oldfiles = 1
" let g:startify_disable_at_vimenter = 1
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
"let g:startify_session_delete_buffers = 0
let g:startify_change_to_dir = 0
" let g:startify_padding_left = 3
"let g:startify_change_to_vcs_root = 0  " vim-rooter has same feature
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ 'bundle/.*/doc',
      \ ]

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['nerdtree','help', 'man', 'startify', 'vimfiler']
" }

" textobj {
let g:wildfire_objects = {
            \ "*" : ["i'", 'i"', "i)", "if", "i]", "i}", "ip"],
            \ "html,xml" : ["at"]}
" }

" ctrlp {
" ctrlp: invoke by <ctrl-p>
let g:ctrlp_working_path_mode = ''
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
let g:ctrlp_follow_symlinks = 2
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file':  '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
let g:ctrlp_reuse_window = 'exproject\|nerdtree\|netrw\|help\|quickfix'
let g:ctrlp_by_filename = 1
let g:ctrlp_match_current_file = 1
" let g:ctrlp_user_command_async = 1
let g:ctrlp_switch_buffer = ''
" CtrlP extensions
let g:ctrlp_extensions = ['funky']
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
" if executable('rg') && !exists('g:ctrlp_user_command')
if !exists('g:ctrlp_user_command')
    let g:ctrlp_user_command = 'rg %s --no-ignore --hidden --files -g "" '
                \ . join(Generate_ignore(g:vim_wildignore,'rg',1))
endif

if !exists('g:ctrlp_match_func') && (has('python') || has('python3'))
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch'  }
endif

let g:ctrlp_prompt_mappings = {
\ 'ToggleRegex()':        ['<c-q>'],
\ 'PrtInsert("c")':       ['<c-c>'],
\ 'PrtInsert("r")':       ['<c-r>'],
\ 'PrtInsert("s")':       ['<c-s>'],
\ 'PrtInsert("w")':       ['<c-g>'],
\ }
" let g:ctrlp_cmd = 'CtrlPBuffer'
"funky
nnoremap <Leader>fm :CtrlPModified<CR>
nnoremap <Leader>fg :CtrlPBranch<CR>
nnoremap <Leader>fu :CtrlPFunky<Cr>
nnoremap <leader>fb :CtrlPBuffer<CR>
" nnoremap <leader>ff :CtrlP<CR>
nnoremap <leader>fr :CtrlPMRU<CR>
nnoremap <leader>fl :CtrlPMRUFiles<CR>

nnoremap <Leader>fc :let g:ctrlp_default_input = expand('<cword>') \|
    \ call ctrlp#init(0) \| unlet g:ctrlp_default_input<CR>
" }

"ctrlsf {
"---------------------------------------------------------------------
" 设置CtrlSF使用的搜索工具,默认使用ag,如果没有ag,则考虑使用ack
let g:ctrlsf_ackprg = 'rg'
" if !executable(g:ctrlsf_ackprg)
"     let g:ctrlsf_ackprg = 'ag'
" endif
" 窗口大小
" let g:ctrlsf_debug_mode = 1
if OSX()
    let g:ctrlsf_winsize='20%'
else
    let g:ctrlsf_winsize='10'
endif
" 是否在ctrlsf搜索结果打开其他窗口时,关闭搜索结果窗口
let g:ctrlsf_auto_close = 0
let g:ctrlsf_position = 'bottom'
" 大小写敏感
let g:ctrlsf_case_sensitive = 'yes'
" 默认搜索路径, 设置为project则从本文件的工程目录搜索
let g:ctrlsf_default_root = 'project+wf'
" 工程目录的顶级文件夹
let g:ctrlsf_ignore_dir = ['.exvim', '.git', '.hg', '.svn', '.bzr', '_darcs']
" let g:ctrlsf_vcs_folder = ['.exvim', '.git', '.hg', '.svn', '.bzr', '_darcs']
" make result windows compact
let g:ctrlsf_indent = 2
" width or height
" 显示的上下文函数
let g:ctrlsf_context = '-B 0 -A 0'
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_auto_focus = {
            \ "at" : "done",
            \ "duration_less_than": 2000
            \ }
let g:ctrlsf_extra_backend_args = {
            \ 'rg': '--vimgrep --hidden'
            \ }
" 高亮匹配行: o->打开的目标文件;p->预览文件
" let g:ctrlsf_selected_line_hl = 'op'
let g:ctrlsf_mapping = {
            \ "open": { "key": "<CR>", "suffix": "<C-w>p" },
            \ "next": "<C-n>",
            \ "prev": "<C-p>",
            \ "quit": ["q","<Esc>"],
            \ }
nmap <Leader>st :CtrlSFToggle<CR>
nmap <Leader>ss :CtrlSF -W <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>sg :CtrlSF<Space>
nmap <Leader>si :CtrlSF -I <Space>
nmap <Leader>sr :CtrlSF -R <Space>
nmap <Leader>sn <Plug>CtrlSFCwordPath
nmap <Leader>sc <Plug>CtrlSFCwordExec
nmap <Leader>sp <Plug>CtrlSFPwordExec
" }

" nerdtree {
" ---------------------------------------------------

let g:NERDTreeWinSize = 30
let g:NERDTreeMouseMode = 1
let g:NERDTreeMapToggleZoom = '<Space>'
let g:nerdtree_tabs_open_on_gui_startup=0
let g:nerdtree_tabs_open_on_new_tab=0
let g:NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1
let g:NERDCustomDelimiters = {
            \ 'vimentry': { 'left': '--' },
            \ }
map <leader>nn <plug>NERDTreeTabsToggle<CR>
" map <F2> <plug>NERDTreeTabsToggle<CR>
map <F11> <Plug>NERDCommenterAlignBoth
map <C-F11> <Plug>NERDCommenterUncomment
" }

" vim-markdown {
if OSX()
    let g:mkdp_path_to_chrome="open -a Google\\ Chrome"
endif
let g:mkdp_auto_close=1
" nmap <F7> <Plug>MarkdownPreview
" nmap <F8> <Plug>StopMarkdownPreview
" }

" lint {
" When writing a buffer.
call neomake#configure#automake('w')
" 1 open list and move cursor 2 open list without move cursor
let g:neomake_open_list =  0
let g:neomake_verbose =  0
let g:neomake_lua_enabled_makers = ['luacheck']
let g:neomake_lua_luacheck_exe = expand('~/.luarocks/bin/luacheck')
let g:neomake_error_sign = get(g:, 'neomake_error_sign', {
            \ 'text': '✖',
            \ })
let g:neomake_warning_sign = get(g:, 'neomake_warning_sign', {
            \ 'text': '➤',
            \ })
let g:neomake_info_sign = get(g:, 'neomake_info_sign', {
            \ 'text': '🛈',
            \ })
nnoremap <silent> <leader>el :lopen<CR>

nnoremap <silent> <leader>ec :lclose<CR>
nnoremap <silent> <leader>ee :lnext<CR>
nnoremap <silent> <leader>en :lnext<CR>
nnoremap <silent> <leader>ep :lprevious<CR>
nnoremap <silent> <leader>eN :lNext<CR>
" }

" autocomplete {
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" let g:neocomplete#max_list = 10
" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions',
    \ 'lua' : $HOME.'/.vim/bundle/vim-quick-community/key-dict'
        \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
    if exists(':NeoCompleteLock')==2
        exe 'NeoCompleteLock'
    endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
    if exists(':NeoCompleteUnlock')==2
        exe 'NeoCompleteUnlock'
    endif
endfunction
" " ---------------------------------------------------
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" " ---------------------------------------------------
" }

" snippet {
" choose a snippet plugin
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/snippets'

function! CleverTab()
    if neosnippet#expandable_or_jumpable()
        return "\<Plug>(neosnippet_expand_or_jump)"
    elseif pumvisible()
        return "\<C-n>"
    else
        return neocomplete#start_manual_complete()
    endif
endfunction

imap <expr> <Tab> CleverTab()
smap <expr> <Tab> CleverTab()

function! SuperTab_Shift() abort
    return pumvisible() ? "\<C-p>" : "\<Plug>delimitMateS-Tab"
endfunction
imap <silent><expr><S-TAB> SuperTab_Shift()
smap <silent><expr><S-TAB> SuperTab_Shift()
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
" }

" editor {
nmap <leader><leader> <Plug>(easymotion-prefix)
nmap <leader><leader>f <Plug>(easymotion-sn)
nmap <leader><leader>j <Plug>(easymotion-j)
nmap <leader><leader>k <Plug>(easymotion-k)
nmap <leader><leader>l <Plug>(easymotion-lineforward)
nmap <leader><leader>h <Plug>(easymotion-linebackward)
nmap <leader><leader>. <Plug>(easymotion-repeat)
nmap <leader><leader>g <Plug>(easymotion-jumptoanywhere)
vmap <leader><leader> <Plug>(easymotion-prefix)
vmap <leader><leader>f <Plug>(easymotion-sn)
vmap <leader><leader>j <Plug>(easymotion-j)
vmap <leader><leader>k <Plug>(easymotion-k)
vmap <leader><leader>l <Plug>(easymotion-lineforward)
vmap <leader><leader>h <Plug>(easymotion-linebackward)
vmap <leader><leader>. <Plug>(easymotion-repeat)
vmap <leader><leader>g <Plug>(easymotion-jumptoanywhere)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

let g:SearchHighlighting_NoJump = 0
let g:SearchHighlighting_ExtendStandardCommands = 1
nmap <Leader>*  <Plug>SearchHighlightingGStar
nmap <Leader>g* <Plug>SearchHighlightingStar
vmap <Leader>*  <Plug>SearchHighlightingGStar

" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------

nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
nmap <Leader>a=> :Tabularize /=><CR>
vmap <Leader>a=> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
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
" nerdcommenter: invoke by <leader>c<space>, <leader>cl, <leader>cu, <F11> or <C-F11>
" ---------------------------------------------------

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" " ---------------------------------------------------

" undotree: invoke by <Leader>u
" ---------------------------------------------------

nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 4

" ex-showmarks: invoke by m... or <leader>mm, <leader>ma
" ---------------------------------------------------

" TODO: bootleq/ShowMarks on github is well organized in code, but have lots
" bugs, consider merge his code and fixes the bugs
let g:showmarks_enable = 1
let g:showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:showmarks_ignore_type = 'hqm' " Ignore help, quickfix, non-modifiable buffers
" Hilight lower & upper marks
let g:showmarks_hlline_lower = 1
let g:showmarks_hlline_upper = 0

" vim-color-solarized
" ---------------------------------------------------
let g:gruvbox_italic = get(g:, 'gruvbox_italic', 0)
" }

" lua {
let g:lua_define_completefunc = 0
let g:lua_define_omnifunc = 0
let g:lua_define_completion_mappings = 0
let lua_version = 5
let lua_subversion = 1
" }
" git {

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_max_signs = 10000

" nnoremap <silent> <leader>gs :Gina status<CR>
nnoremap <silent> <leader>gb :Gina blame<CR>
nnoremap <silent> <leader>gV :GV!<CR>
nnoremap <silent> <leader>gv :GV<CR>
" }

" vim-airline {
" ---------------------------------------------------

if has('gui_running')
    let g:airline_powerline_fonts = 1
else
    let g:airline_powerline_fonts = 1
endif

" let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#enabled = 1 " NOTE: When you open lots of buffers and typing text, it is so slow.
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_section_b = "%{fnamemodify(bufname('%'),':p:.:h').'/'}"
" let g:airline_section_c = '%t'
let g:airline_section_y = 'B:%{bufnr("%")} W:%{winnr()}'
if exists('g:syntastic')
    let g:airline_section_warning = airline#section#create(['syntastic'])
else
    let g:airline_section_warning = airline#section#create(['neomake'])
endif
" }

" haskell {
let g:haskell_conceal = 0
let g:haskell_conceal_enumerations = 0
let g:haskell_tabular = 0

" unicode display

" hoogle
let g:haskellmode_completion_ghc=0
let g:haskellmode_completion_haddock=0
let g:ghc_symbolcache=1
if OSX()
    let g:haddock_browser="Chrome.app"
    let g:haddock_docdir='~/.stack/programs/x86_64-osx/ghc-8.2.2/share/doc/ghc-8.2.2/html'
elseif WINDOWS()
    let g:haddock_browser="firefox.exe"
    let g:haddock_docdir='C:/Users/Administrator/AppData/Local/Programs/stack/i386-windows/ghc-8.0.2/doc/html'
    let g:ghc='C:/Users/Administrator/AppData/Local/Programs/stack/i386-windows/ghc-8.0.2/bin/ghc.exe'
else
    let g:haddock_browser="firefox.exe"
    let g:haddock_docdir='~/.stack/programs/x86_64-linux/ghc-ncurses6-8.0.2/share/doc/ghc-8.0.0/html'
endif

" ghc-mode

" stylish
" Use stylish haskell instead of par for haskell buffers
autocmd FileType haskell let &formatprg="stylish-haskell"
autocmd FileType haskell compiler ghc

" haskell repl

" Workaround vim-commentary for Haskell
autocmd FileType haskell setlocal commentstring=--\ %s
" Workaround broken colour highlighting in Haskell
autocmd FileType haskell setlocal nospell
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" Type of expression under cursor
nmap <silent> <leader>nt :GhcModType<CR>
nmap <silent> <leader>nr :GhcModTypeClear<CR>
" Insert type of expression under cursor
nmap <silent> <leader>nT :GhcModTypeInsert<CR>
" Hoogle the word under the cursor
nnoremap <silent> <leader>nh :Hoogle<CR>

" Hoogle and prompt for input
nnoremap <leader>nH :Hoogle

" Hoogle for detailed documentation (e.g. "Functor")
nnoremap <silent> <leader>ni :HoogleInfo<CR>

" Hoogle for detailed documentation and prompt for input
nnoremap <leader>nI :HoogleInfo

" Hoogle, close the Hoogle window
nnoremap <silent> <leader>nc :HoogleClose<CR>
" if !executable("ghcmod")
    " autocmd BufWritePost *.hs GhcModCheckAndLintAsync
" endif
" let g:lua_define_omnifunc = 0

" }

" util {
nmap <leader>ww <Plug>WinModeStart
let g:win_mode_default ='resize'

" }

" buffer {
nnoremap <Leader>bd :Bdelete<CR>
" nnoremap <F4> :Bdelete<CR>
" nnoremap <F5> :edit ++ff=dos<CR>

nnoremap <expr> <Leader>b1 tweak#wtb_switch#key_leader_bufnum(1)
nnoremap <expr> <Leader>b2 tweak#wtb_switch#key_leader_bufnum(2)
nnoremap <expr> <Leader>b3 tweak#wtb_switch#key_leader_bufnum(3)
nnoremap <expr> <Leader>b4 tweak#wtb_switch#key_leader_bufnum(4)
nnoremap <expr> <Leader>b5 tweak#wtb_switch#key_leader_bufnum(5)
nnoremap <expr> <Leader>b6 tweak#wtb_switch#key_leader_bufnum(6)
nnoremap <expr> <Leader>b7 tweak#wtb_switch#key_leader_bufnum(7)
nnoremap <expr> <Leader>b8 tweak#wtb_switch#key_leader_bufnum(8)
nnoremap <expr> <Leader>b9 tweak#wtb_switch#key_leader_bufnum(9)
" }

" exvim {
" ex-gsearch
" ---------------------------------------------------

let g:ex_gsearch_ignore_case = 0
call exgsearch#register_hotkey( 100, 0, '<leader>gs', ":EXGSearchToggle<CR>", 'Toggle global search window.' )
call exgsearch#register_hotkey( 101, 0, '<leader>gg', ":EXGSearchCWord<CR>", 'Search current word.' )
call exgsearch#register_hotkey( 102, 0, '<leader><S-f>', ":GSW ", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 102, 0, '<leader>gf', ":GSW <C-R>*<CR>", 'Shortcut for :GSW' )

" ex-tagselect
" ---------------------------------------------------

call extags#register_hotkey( 100, 0, '<leader>ts', ":EXTagsToggle<CR>", 'Toggle tag select window.' )
call extags#register_hotkey( 101, 0, '<leader>tt', ":EXTagsCWord<CR>", 'Tag select current word.' )
"nnoremap <unique> <leader>] :exec 'ts ' . expand('<cword>')<CR>

let g:ex_symbol_select_cmd = 'TS'
"}

" fix colorscheme {

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number
hi VertSplit ctermbg=NONE guibg=NONE
" }

" register / {
function! MakePattern(text)
  let pat = escape(a:text, '\')
  let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
  let pat = substitute(pat, '^\_s\+', '\\s\\*', '')
  let pat = substitute(pat, '\_s\+',  '\\_s\\+', 'g')
  return '\\V' . escape(pat, '\"')
endfunction
vnoremap <silent> <F3> :<C-U>let @/="<C-R>=MakePattern(@*)<CR>"<CR>:set hls<CR>

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

" SynCheck {
" 检测函数（检测光标位置处文字的样式名）
function! SynStack()
    echo map(synstack(line('.'),col('.')),'synIDattr(v:val, "name")')
endfunc

" 绑定检测键位（按键后样式名信息会输出在指令栏的位置）
nnoremap <leader>yi :call SynStack()<CR>
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

noremap <Leader>ve :call EditVimrc13Config()<CR>
noremap <Leader>vr :source $HOME/.vimrc<CR>
noremap <Leader>vn :NeoSnippetEdit<CR>
" }

" Code folding options {
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>
" }

" nav {
nnoremap <leader>th  :tabfirst<CR>
nnoremap <leader>tj  :tabnext<CR>
nnoremap <leader>tk  :tabprev<CR>
nnoremap <leader>tl  :tablast<CR>
" nnoremap <leader>tt  :tabedit<Space>
" nnoremap <leader>tn  :tabnext<Space>
nnoremap <leader>tn  :tabnew<CR>
nnoremap <leader>tc  :tabclose<CR>
nnoremap <leader>tm  :tabm<Space>
nnoremap <leader>td  :tabclose<CR>
nnoremap <leader>t1  1gt
nnoremap <leader>t2  2gt
nnoremap <leader>t3  3gt
nnoremap <leader>t4  4gt
nnoremap <leader>t5  5gt
nnoremap <leader>t6  6gt
nnoremap <leader>t7  7gt
nnoremap <leader>t8  8gt
nnoremap <leader>t9  9gt

" Alternatively use
"nnoremap <leader>th :tabnext<CR>
"nnoremap <leader>tl :tabprev<CR>
"nnoremap <leader>tn :tabnew<CR>

nnoremap <leader>1  1<C-W>W
nnoremap <leader>2  2<C-W>W
nnoremap <leader>3  3<C-W>W
nnoremap <leader>4  4<C-W>W
nnoremap <leader>5  5<C-W>W
nnoremap <leader>6  6<C-W>W
nnoremap <leader>7  7<C-W>W
nnoremap <leader>8  8<C-W>W
nnoremap <leader>9  9<C-W>W
" }

" vim:ts=4:sw=4:sts=4 et fdm=marker:
