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

" if dein#load_state(g:ex_dein_path)
call dein#begin(g:ex_dein_path)
" call dein#add('Shougo/dein.vim')
" Plugin 'Shougo/dein.vim'

" man.vim: invoked by :Man {name}
" source $VIMRUNTIME/ftplugin/man.vim
" matchit
" source $VIMRUNTIME/macros/matchit.vim
Plugin 'andymass/vim-matchup', {'merged' : 0}

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'Shougo/vimproc'

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
Plugin 'mhinz/vim-startify'
let g:startify_custom_header = [
        \ '',
        \ '',
        \ '                                     VVVVVVVV           VVVVVVVVIIIIIIIIIIMMMMMMMM               MMMMMMMM     ',
        \ '                                     V::::::V           V::::::VI::::::::IM:::::::M             M:::::::M     ',
        \ '                                     V::::::V           V::::::VI::::::::IM::::::::M           M::::::::M     ',
        \ '                                     V::::::V           V::::::VII::::::IIM:::::::::M         M:::::::::M     ',
        \ '                                      V:::::V           V:::::V   I::::I  M::::::::::M       M::::::::::M     ',
        \ '                                       V:::::V         V:::::V    I::::I  M:::::::::::M     M:::::::::::M     ',
        \ '                                        V:::::V       V:::::V     I::::I  M:::::::M::::M   M::::M:::::::M     ',
        \ '                                         V:::::V     V:::::V      I::::I  M::::::M M::::M M::::M M::::::M     ',
        \ '                                          V:::::V   V:::::V       I::::I  M::::::M  M::::M::::M  M::::::M     ',
        \ '                                           V:::::V V:::::V        I::::I  M::::::M   M:::::::M   M::::::M     ',
        \ '                                            V:::::V:::::V         I::::I  M::::::M    M:::::M    M::::::M     ',
        \ '                                             V:::::::::V          I::::I  M::::::M     MMMMM     M::::::M     ',
        \ '                                              V:::::::V         II::::::IIM::::::M               M::::::M     ',
        \ '                                               V:::::V          I::::::::IM::::::M               M::::::M     ',
        \ '                                                V:::V           I::::::::IM::::::M               M::::::M     ',
        \ '                                                 VVV            IIIIIIIIIIMMMMMMMM               MMMMMMMM     ',
        \ '',
        \ '',
        \ ]
let g:startify_session_dir = $HOME .  '/.data/' . ( has('nvim') ? 'nvim' : 'vim' ) . '/session'
let g:startify_files_number = 6
let g:startify_list_order = [
      \ ['   These are my bookmarks:'],
      \ 'bookmarks',
      \ ['   My most recently used files in the current directory:'],
      \ 'dir',
      \ ['   My most recently used files:'],
      \ 'files',
      \ ['   These are my sessions:'],
      \ 'sessions',
      \ ]
let g:startify_bookmarks = [{'c' : '~/Documents/dev/kingdom-of-heaven-client/koh.exvim'},
            \ {'k': '~/Documents/dev/kingdom-of-heaven-client/koh-c.exvim'},
            \ {'x': '~/Documents/dev/koh/koh.exvim'},
            \'~/.vimrc',
            \'~/.vimrc.plugins',
            \'~/.zshrc',
            \]
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

"Plugin 'rhysd/conflict-marker.vim'
"Plugin 'jiangmiao/auto-pairs'
Plugin 'terryma/vim-multiple-cursors'
" Plugin 'vim-scripts/sessionman.vim'
" nmap <leader>sl :SessionList<CR>
" nmap <leader>ss :SessionSave<CR>
" nmap <leader>sc :SessionClose<CR>
Plugin 'nathanaelkane/vim-indent-guides'
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_exclude_filetypes = ['nerdtree','help', 'man', 'startify', 'vimfiler']
" }

" incsearch {
" let g:plug_incsearch = 1
if exists('g:plug_incsearch')
    Plugin 'haya14busa/incsearch.vim'
    Plugin 'haya14busa/incsearch-fuzzy.vim'
    " Plugin 'haya14busa/vim-asterisk'
    " Plugin 'osyo-manga/vim-over'
    Plugin 'haya14busa/incsearch-easymotion.vim'
    let g:incsearch#auto_nohlsearch = 1
    " map /  <Plug>(incsearch-forward)
    " map ?  <Plug>(incsearch-backward)
    " map g/ <Plug>(incsearch-stay)
    " map n  <Plug>(incsearch-nohl-n)
    " map N  <Plug>(incsearch-nohl-N)
    " map *  <Plug>(incsearch-nohl-*)
    " map #  <Plug>(incsearch-nohl-#)
    " map g* <Plug>(incsearch-nohl-g*)
    " map g# <Plug>(incsearch-nohl-g#)
    " map z/ <Plug>(incsearch-easymotion-/)
    " map z? <Plug>(incsearch-easymotion-?)
    " map zg/ <Plug>(incsearch-easymotion-stay)
    function! s:config_easyfuzzymotion(...) abort
        return extend(copy({
                    \   'converters': [incsearch#config#fuzzy#converter()],
                    \   'modules': [incsearch#config#easymotion#module()],
                    \   'keymap': {"\<CR>": '<Over>(easymotion)'},
                    \   'is_expr': 0,
                    \   'is_stay': 1
                    \ }), get(a:, 1, {}))
    endfunction

    noremap <silent><expr> <leader>/ incsearch#go(<SID>config_easyfuzzymotion())
endif

" }

" textobj {
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-line'

Plugin 'kana/vim-textobj-function'
Plugin 'binesiyu/vim-textobj-function-syntax'

" Plugin 'spacewander/vim-textobj-lua'
" omap <buffer> ab <Plug>(textobj-lua-block-a)
" omap <buffer> ib <Plug>(textobj-lua-block-i)
" xmap <buffer> ab <Plug>(textobj-lua-block-a)
" xmap <buffer> ib <Plug>(textobj-lua-block-i)

Plugin 'reedes/vim-textobj-sentence'
augroup textobj_sentence
  autocmd!
  autocmd FileType markdown call textobj#sentence#init()
  autocmd FileType textile call textobj#sentence#init()
  autocmd FileType text call textobj#sentence#init()
augroup END

Plugin 'reedes/vim-textobj-quote'
augroup textobj_quote
    autocmd!
    autocmd FileType markdown call textobj#quote#init()
    autocmd FileType textile call textobj#quote#init()
    autocmd FileType text call textobj#quote#init({'educate': 0})
augroup END

Plugin 'gcmt/wildfire.vim'
let g:wildfire_objects = {
            \ "*" : ["i'", 'i"', "i)", "if", "i]", "i}", "ip"],
            \ "html,xml" : ["at"]}
" }

" ctrlp {
let g:plug_ctrlp = 1
if exists('g:plug_ctrlp')
    " ctrlp: invoke by <ctrl-p>
    Plugin 'kien/ctrlp.vim'
    Plugin 'tacahiroy/ctrlp-funky'
    Plugin 'jasoncodes/ctrlp-modified.vim'
    let g:ctrlp_working_path_mode = ''
    let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
    let g:ctrlp_follow_symlinks = 2
    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file':  '\.exe$\|\.so$\|\.dll$\|\.pyc$' }
    let g:ctrlp_reuse_window = 'exproject\|nerdtree\|netrw\|help\|quickfix'
    let g:ctrlp_by_filename = 1
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
    " nnoremap <leader>fa :Ack<CR>
endif
" }

" denite {
let g:plug_denite = 1
if exists('g:plug_denite')
    " Plugin 'Shougo/denite.nvim',{ 'merged' : 0,'lazy' : 0}
    Plugin 'Shougo/denite.nvim'
    if !dein#check_install('denite.nvim')
        " denite option
        let s:denite_options = {
                    \ 'default' : {
                    \ 'winheight' : 10,
                    \ 'mode' : 'normal',
                    \ 'quit' : 'true',
                    \ 'highlight_matched_char' : 'MoreMsg',
                    \ 'highlight_matched_range' : 'MoreMsg',
                    \ 'direction': 'rightbelow',
                    \ 'statusline' : has('patch-7.4.1154') ? v:false : 0,
                    \ 'prompt' : '➭',
                    \ 'cursor_pos' : '$',
                    \ }}

        function! s:profile(opts) abort
            for fname in keys(a:opts)
                for dopt in keys(a:opts[fname])
                    call denite#custom#option(fname, dopt, a:opts[fname][dopt])
                endfor
            endfor
        endfunction

        call s:profile(s:denite_options)

        " buffer source
        call denite#custom#var(
                    \ 'buffer',
                    \ 'date_format', '%m-%d-%Y %H:%M:%S')

        " denite command
        " For ripgrep
        call denite#custom#var('file_rec', 'command',
                    \ ['rg', '--hidden', '--files', '--glob', '!.git', '--glob', '']
                    \ + Generate_ignore(g:vim_wildignore, 'rg')
                    \ )

        call denite#custom#alias('source', 'file_rec/git', 'file_rec')
        call denite#custom#var('file_rec/git', 'command',
                    \ ['git', 'ls-files', '-co', '--exclude-standard'])
        " Ripgrep command on grep source
        call denite#custom#var('grep', 'command', ['rg'])
        call denite#custom#var('grep', 'default_opts',
                    \ ['--vimgrep', '--no-heading'])
        call denite#custom#var('grep', 'recursive_opts', [])
        call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
        call denite#custom#var('grep', 'separator', ['--'])
        call denite#custom#var('grep', 'final_opts', [])
        " KEY MAPPINGS
        let s:insert_mode_mappings = [
                    \  ['<C-J>', '<denite:move_to_next_line>', 'noremap'],
                    \  ['<C-K>', '<denite:move_to_previous_line>', 'noremap'],
                    \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
                    \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
                    \  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
                    \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
                    \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
                    \  ['<C-Y>', '<denite:redraw>', 'noremap'],
                    \ ]

        " \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
        " \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
        let s:normal_mode_mappings = [
                    \   ["'", '<denite:toggle_select_down>', 'noremap'],
                    \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
                    \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
                    \   ['gg', '<denite:move_to_first_line>', 'noremap'],
                    \   ['st', '<denite:do_action:tabopen>', 'noremap'],
                    \   ['sg', '<denite:do_action:vsplit>', 'noremap'],
                    \   ['sv', '<denite:do_action:split>', 'noremap'],
                    \   ['q', '<denite:quit>', 'noremap'],
                    \   ['r', '<denite:redraw>', 'noremap'],
                    \   ['<Esc>', '<denite:quit>', 'noremap'],
                    \ ]

        for s:m in s:insert_mode_mappings
            call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
        endfor
        for s:m in s:normal_mode_mappings
            call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
        endfor

        unlet s:m s:insert_mode_mappings s:normal_mode_mappings


        nnoremap <leader>fd :Denite file_rec<CR>
        " nnoremap <leader>fb :Denite buffer<CR>
        nnoremap <leader>fg :Denite grep<CR>
        nnoremap <leader>fa :Denite grep<CR>
        nnoremap <leader>fc :DeniteCursorWord grep<CR>
    endif
endif
" }

" unite {
let g:plug_unite = 1
if exists('g:plug_unite')
    " Plugin  'Shougo/unite.vim',{ 'merged' : 0 }
    Plugin  'Shougo/unite.vim'
    Plugin  'Shougo/neomru.vim'
    if !dein#check_install('unite.vim')
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])
        call unite#custom#profile('default', 'context', {
                    \   'safe': 0,
                    \   'start_insert': 0,
                    \   'ignorecase' : 1,
                    \   'short_source_names': 1,
                    \   'update_time': 200,
                    \   'direction': 'rightbelow',
                    \   'winwidth': 40,
                    \   'winheight': 10,
                    \   'max_candidates': 100,
                    \   'no_auto_resize': 1,
                    \   'vertical_preview': 1,
                    \   'cursor_line_time': '0.10',
                    \   'hide_icon': 0,
                    \   'candidate-icon': ' ',
                    \   'marked_icon': '✓',
                    \   'prompt' : '➭ '
                    \ })
        call unite#custom#profile('source/neobundle/update', 'context', {
                    \   'start_insert' : 0,
                    \ })

        let g:unite_source_buffer_time_format = get(g:,
                    \ 'unite_source_buffer_time_format', '(%m-%d-%Y %H:%M:%S) ')
        let g:unite_split_rule = get(g:, 'unite_split_rule', 'botright')
        let g:unite_winheight = get(g:, 'unite_winheight', 25)

        function! Unite_my_settings()
            " Overwrite settings.
            setlocal nowrap

            " Play nice with supertab
            let b:SuperTabDisabled=1
            " Enable navigation with control-j and control-k in insert mode
            imap <buffer> <C-n>     <Plug>(unite_select_next_line)
            nmap <buffer> <C-n>     <Plug>(unite_select_next_line)
            imap <buffer> <TAB>     <Plug>(unite_select_next_line)
            nmap <buffer> <TAB>     <Plug>(unite_select_next_line)
            imap <buffer> <C-p>     <Plug>(unite_select_previous_line)
            nmap <buffer> <C-p>     <Plug>(unite_select_previous_line)
            imap <buffer> <S-Tab>   <Plug>(unite_select_previous_line)
            nmap <buffer> <S-Tab>   <Plug>(unite_select_previous_line)


            "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

            imap <buffer><expr> j unite#smart_map('j', '')
            imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
            imap <buffer> '     <Plug>(unite_quick_match_default_action)
            nmap <buffer> '     <Plug>(unite_quick_match_default_action)
            imap <buffer><expr> x
                        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
            nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
            nmap <buffer> <Esc>     <Plug>(unite_exit)
            nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
            imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
            imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
            nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
            nmap <buffer> <C-e>     <Plug>(unite_toggle_auto_preview)
            imap <buffer> <C-e>     <Plug>(unite_toggle_auto_preview)
            nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
            imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
            nnoremap <silent><buffer><expr> l
                        \ unite#smart_map('l', unite#do_action('default'))

            let unite = unite#get_current_unite()
            if unite.profile_name ==# 'search'
                nnoremap <silent><buffer><expr> r     unite#do_action('replace')
            else
                nnoremap <silent><buffer><expr> r     unite#do_action('rename')
            endif

            nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
            nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
                        \ empty(unite#mappings#get_current_filters()) ?
                        \ ['sorter_reverse'] : [])

            " Runs "split" action by <C-s>.
            imap <silent><buffer><expr> <C-s>     unite#do_action('split')
        endfunction
        augroup unite_buffer_feature
            autocmd FileType unite call Unite_my_settings()
        augroup END
        nnoremap <silent><leader>fm  :<C-u>Unite -start-insert mapping<CR>
    endif


    function! Vimfiler_init() abort
        let g:vimfiler_as_default_explorer = get(g:, 'vimfiler_as_default_explorer', 1)
        let g:vimfiler_restore_alternate_file = get(g:, 'vimfiler_restore_alternate_file', 1)
        let g:vimfiler_tree_indentation = get(g:, 'vimfiler_tree_indentation', 1)
        let g:vimfiler_tree_leaf_icon = get(g:, 'vimfiler_tree_leaf_icon', '')
        let g:vimfiler_tree_opened_icon = get(g:, 'vimfiler_tree_opened_icon', '▼')
        let g:vimfiler_tree_closed_icon = get(g:, 'vimfiler_tree_closed_icon', '►')
        let g:vimfiler_file_icon = get(g:, 'vimfiler_file_icon', '')
        let g:vimfiler_readonly_file_icon = get(g:, 'vimfiler_readonly_file_icon', '*')
        let g:vimfiler_marked_file_icon = get(g:, 'vimfiler_marked_file_icon', '√')
        let g:vimfiler_direction = get(g:, 'vimfiler_direction', 'rightbelow')
        "let g:vimfiler_preview_action = 'auto_preview'
        let g:vimfiler_ignore_pattern = get(g:, 'vimfiler_ignore_pattern', [
                    \ '^\.git$',
                    \ '^\.DS_Store$',
                    \ '^\.init\.vim-rplugin\~$',
                    \ '^\.netrwhist$',
                    \ '\.class$',
                    \ '^\.'
                    \])

        call vimfiler#custom#profile('default', 'context', {
                    \ 'explorer' : 1,
                    \ 'winwidth' : 30,
                    \ 'winminwidth' : 30,
                    \ 'toggle' : 1,
                    \ 'auto_expand': 1,
                    \ 'direction' : g:vimfiler_direction,
                    \ 'parent': 0,
                    \ 'status' : 1,
                    \ 'safe' : 0,
                    \ 'split' : 1,
                    \ 'hidden': 1,
                    \ 'no_quit' : 1,
                    \ 'force_hide' : 0,
                    \ 'auto_cd' : 1,
                    \ })

        augroup vfinit
            au!
            autocmd FileType vimfiler call s:vimfilerinit()
        augroup END
        function! s:vimfilerinit()
            setl nonumber
            setl norelativenumber

            silent! nunmap <buffer> <Space>
            silent! nunmap <buffer> <C-l>
            silent! nunmap <buffer> <C-j>
            silent! nunmap <buffer> E
            silent! nunmap <buffer> -
            silent! nunmap <buffer> s

            nnoremap <silent><buffer><expr> sg  vimfiler#do_action('vsplit')
            nnoremap <silent><buffer><expr> sv  vimfiler#do_action('split')
            nnoremap <silent><buffer><expr> st  vimfiler#do_action('tabswitch')
            nmap <buffer> gx      <Plug>(vimfiler_execute_vimfiler_associated)
            nmap <buffer> '       <Plug>(vimfiler_toggle_mark_current_line)
            nmap <buffer> v       <Plug>(vimfiler_quick_look)
            nmap <buffer> p       <Plug>(vimfiler_preview_file)
            nmap <buffer> V       <Plug>(vimfiler_clear_mark_all_lines)
            nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
            nmap <buffer> <Tab>   <Plug>(vimfiler_switch_to_other_window)
            nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
            nmap <buffer> <Left>  <Plug>(vimfiler_smart_h)
            nmap <buffer> <Right> <Plug>(vimfiler_smart_l)
        endf
        noremap <silent> <leader>nv :VimFiler<CR>
    endfunction
    Plugin 'Shougo/vimfiler.vim',{'on_cmd' : ['VimFiler', 'VimFilerBufferDir'],'hook_source' : function('Vimfiler_init'), 'on_path': '.*'}
endif
" }

" nerdtree {
" ---------------------------------------------------
let g:plug_nerdtree = 1
if exists('g:plug_nerdtree')
    Plugin 'scrooloose/nerdtree'
    Plugin 'jistr/vim-nerdtree-tabs'

    let g:NERDTreeWinSize = 30
    let g:NERDTreeMouseMode = 1
    let g:NERDTreeMapToggleZoom = '<Space>'
    let g:nerdtree_tabs_open_on_gui_startup=0
    let g:nerdtree_tabs_open_on_new_tab=0
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    map <leader>nn <plug>NERDTreeTabsToggle<CR>
    " map <F2> <plug>NERDTreeTabsToggle<CR>
endif
" }

" vim-markdown {
Plugin 'plasticboy/vim-markdown'
Plugin 'iamcco/markdown-preview.vim'
if OSX()
    let g:mkdp_path_to_chrome="open -a Google\\ Chrome"
endif
let g:mkdp_auto_close=1
" nmap <F7> <Plug>MarkdownPreview
" nmap <F8> <Plug>StopMarkdownPreview
" }

" lint {
" syntastic: invoke when you save file and have syntac-checker
" ---------------------------------------------------
" let g:syntastic = 1
if exists('g:syntastic')
    Plugin 'scrooloose/syntastic'
    let g:syntastic_lua_checkers = ["luac", "luacheck"]
    let g:syntastic_lua_luacheck_args = "--no-unused-args"
    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_auto_loc_list = 1
    let syntastic_error_symbol = '✖'
    let syntastic_warning_symbol = '➤'
    let syntastic_info_symbol = '🛈'

    let syntastic_style_error_symbol = '✖'
    let syntastic_style_warning_symbol = '➤'

    if OSX()
        let g:syntastic_lua_luacheck_exec = "~/.luarocks/bin/luacheck"
        " let g:syntastic_lua_luacheck_quiet_messages = {
        " \ "regex": ["accessing undefined variable \'Sora.*","accessing undefined variable \'g.*"]}
    endif

    " this will make html file by Angular.js ignore errors
    let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
    nnoremap <silent> <leader>el :Error<CR>
else
    Plugin 'neomake/neomake'
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
endif

nnoremap <silent> <leader>ec :lclose<CR>
nnoremap <silent> <leader>ee :lnext<CR>
nnoremap <silent> <leader>en :lnext<CR>
nnoremap <silent> <leader>ep :lprevious<CR>
nnoremap <silent> <leader>eN :lNext<CR>
" }

" autocomplete {
if !has('nvim')
let g:plug_neocomplete = 1
endif

if exists('g:plug_neocomplete')
    Plugin 'Shougo/neocomplete'
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
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

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
else
    function! Deoplete_init() abort
        " deoplete options
        let g:deoplete#enable_at_startup = get(g:, 'deoplete#enable_at_startup', 1)
        let g:deoplete#enable_ignore_case = get(g:, 'deoplete#enable_ignore_case', 1)
        let g:deoplete#enable_smart_case = get(g:, 'deoplete#enable_smart_case', 1)
        let g:deoplete#enable_camel_case = get(g:, 'deoplete#enable_camel_case', 1)
        let g:deoplete#enable_refresh_always = get(g:, 'deoplete#enable_refresh_always', 1)
        let g:deoplete#max_abbr_width = get(g:, 'deoplete#max_abbr_width', 0)
        let g:deoplete#max_menu_width = get(g:, 'deoplete#max_menu_width', 0)
        " init deoplet option dict
        let g:deoplete#ignore_sources = get(g:,'deoplete#ignore_sources',{})
        let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
        let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
        let g:deoplete#keyword_patterns = get(g:, 'deoplete#keyword_patterns', {})
        " let g:deoplete#auto_complete_delay = 150

        " sh
        let g:deoplete#ignore_sources.sh = get(g:deoplete#ignore_sources, 'sh', ['around', 'member', 'tag', 'syntax'])

        " go
        let g:deoplete#ignore_sources.go = get(g:deoplete#ignore_sources, 'go', ['omni'])
        call deoplete#custom#source('go', 'mark', '')
        call deoplete#custom#source('go', 'rank', 9999)

        " markdown
        let g:deoplete#ignore_sources.markdown = get(g:deoplete#ignore_sources, 'markdown', ['tag'])

        " perl
        let g:deoplete#omni#input_patterns.perl = get(g:deoplete#omni#input_patterns, 'perl', [
              \'[^. \t0-9]\.\w*',
              \'[^. \t0-9]\->\w*',
              \'[^. \t0-9]\::\w*',
              \])

        " javascript
        "let g:deoplete#omni#input_patterns.javascript = get(g:deoplete#omni#input_patterns, 'javascript', ['[^. \t0-9]\.\w*'])
        let g:deoplete#ignore_sources.javascript = get(g:deoplete#ignore_sources, 'javascript', ['omni'])
        call deoplete#custom#source('ternjs', 'mark', 'tern')
        call deoplete#custom#source('ternjs', 'rank', 9999)

        " typescript
        let g:deoplete#ignore_sources.typescript = get(g:deoplete#ignore_sources, 'typescript', ['tag','omni', 'syntax'])
        call deoplete#custom#source('typescript', 'rank', 9999)
        " gitcommit
        let g:deoplete#omni#input_patterns.gitcommit = get(g:deoplete#omni#input_patterns, 'gitcommit', [
              \'[ ]#[ 0-9a-zA-Z]*',
              \])

        let g:deoplete#ignore_sources.gitcommit = get(g:deoplete#ignore_sources, 'gitcommit', ['neosnippet'])

        " lua
        let g:deoplete#omni_patterns.lua = get(g:deoplete#omni_patterns, 'lua', '.')

        " c c++
        call deoplete#custom#source('clang2', 'mark', '')
        let g:deoplete#ignore_sources.c = get(g:deoplete#ignore_sources, 'c', ['omni'])

        " rust
        let g:deoplete#ignore_sources.rust = get(g:deoplete#ignore_sources, 'rust', ['omni'])
        call deoplete#custom#source('racer', 'mark', '')

        " vim
        let g:deoplete#ignore_sources.vim = get(g:deoplete#ignore_sources, 'vim', ['tag'])

        " clojure
        let g:deoplete#keyword_patterns.clojure = '[\w!$%&*+/:<=>?@\^_~\-\.#]*'
        " neosnippet
        " call deoplete#custom#source('neosnippet', 'rank', 99)

        " public settings
        " call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
        call deoplete#custom#source('_', 'matchers', ['matcher_head'])
        let g:deoplete#ignore_sources._ = get(g:deoplete#ignore_sources, '_', ['around', 'LanguageClient'])
        for key in keys(g:deoplete#ignore_sources)
          if key != '_' && index(keys(get(g:, 'LanguageClient_serverCommands', {})), key) == -1
            let g:deoplete#ignore_sources[key] = g:deoplete#ignore_sources[key] + ['around', 'LanguageClient']
          endif
        endfor
        inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
        set isfname-==

        " Called once right before you start selecting multiple cursors
        function! Multiple_cursors_before()
            call deoplete#disable()
        endfunction

        " Called once only when the multiple selection is canceled (default <Esc>)
        function! Multiple_cursors_after()
            call deoplete#enable()
        endfunction
    endfunction
    Plugin 'Shougo/deoplete.nvim', {
          \ 'on_event' : 'InsertEnter',
          \ 'hook_source' : function('Deoplete_init'),
          \ 'on_path' : '.*',
          \ }
    if !has('nvim')
      Plugin 'roxma/nvim-yarp'
      Plugin 'roxma/vim-hug-neovim-rpc'
    endif
endif

" " ---------------------------------------------------
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" " ---------------------------------------------------
" completesource
Plugin 'Shougo/neco-syntax',          { 'on_event' : 'InsertEnter'}
Plugin 'Shougo/neopairs.vim',         { 'on_event' : 'InsertEnter'}
Plugin 'Raimondi/delimitMate'
" Plugin 'tenfyzhong/CompleteParameter.vim',  {'merged': 0}
" }

" snippet {
" choose a snippet plugin
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
" Plugin 'honza/vim-snippets'
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/snippets'
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
function! SuperTab() abort
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
        return "\<C-n>"
    endif
    if neosnippet#expandable() && getline('.')[col('.')-2] ==# '(' && !pumvisible()
        return "\<Plug>(neosnippet_expand)"
    elseif neosnippet#jumpable()
                \ && getline('.')[col('.')-2] ==# '(' && !pumvisible()
                \ && !neosnippet#expandable()
        return "\<plug>(neosnippet_jump)"
    elseif neosnippet#expandable_or_jumpable() && getline('.')[col('.')-2] !=#'('
        return "\<plug>(neosnippet_expand_or_jump)"
    elseif pumvisible()
        return "\<C-n>"
    " elseif complete_parameter#jumpable(1) && getline('.')[col('.')-2] !=# ')'
        " return "\<plug>(complete_parameter#goto_next_parameter)"
    else
        return "\<tab>"
    endif
endfunction
imap <silent><expr><TAB> SuperTab()
smap <silent><expr><TAB> SuperTab()

function! SuperTab_Shift() abort
    return pumvisible() ? "\<C-p>" : "\<Plug>delimitMateS-Tab"
endfunction
imap <silent><expr><S-TAB> SuperTab_Shift()
smap <silent><expr><S-TAB> SuperTab_Shift()

" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: "\<TAB>"
" }

" vim-easymotion {
" vim-easymotion: invoke by <leader><leader> w,b,e,ge,f,F,h,i,j,k,/
Plugin 'binesiyu/vim-easymotion'
nmap <leader><leader> <Plug>(easymotion-prefix)
nmap <leader><leader>f <Plug>(easymotion-sn)
nmap <leader><leader>j <Plug>(easymotion-j)
nmap <leader><leader>k <Plug>(easymotion-k)
nmap <leader><leader>l <Plug>(easymotion-lineforward)
nmap <leader><leader>h <Plug>(easymotion-linebackward)
nmap <leader><leader>. <Plug>(easymotion-repeat)
nmap <leader><leader>g <Plug>(easymotion-jumptoanywhere)
" vmap f <Plug>(easymotion-prefix)
" vmap ff <Plug>(easymotion-sn)
" vmap fj <Plug>(easymotion-j)
" vmap fk <Plug>(easymotion-k)
" vmap fl <Plug>(easymotion-lineforward)
" vmap fh <Plug>(easymotion-linebackward)
" vmap f. <Plug>(easymotion-repeat)
" vmap fg <Plug>(easymotion-jumptoanywhere)
let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

Plugin 'rhysd/clever-f.vim'
" }

" editor {
" yanked text by highlighting.
" Plugin 'kana/vim-operator-user'
" Plugin 'haya14busa/vim-operator-flashy'
" map y <Plug>(operator-flashy)
" nmap Y <Plug>(operator-flashy)$
" let g:operator#flashy#flash_time =  1000

" tabular: invoke by <leader>= alignment-character
" ---------------------------------------------------
Plugin 'godlygeek/tabular'

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
Plugin 'scrooloose/nerdcommenter'
" Plugin 'tpope/vim-commentary'

let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1
let g:NERDCustomDelimiters = {
            \ 'vimentry': { 'left': '--' },
            \ }
map <F11> <Plug>NERDCommenterAlignBoth
map <C-F11> <Plug>NERDCommenterUncomment

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" " ---------------------------------------------------
Plugin 'Konfekt/FastFold'
Plugin 'Konfekt/FoldText'

" undotree: invoke by <Leader>u
" ---------------------------------------------------
Plugin 'mbbill/undotree'

nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout = 4

" Plugin 'mattn/webapi-vim'
" Plugin 'mattn/gist-vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

" ex-showmarks: invoke by m... or <leader>mm, <leader>ma
" ---------------------------------------------------
Plugin 'exvim/ex-showmarks'

" TODO: bootleq/ShowMarks on github is well organized in code, but have lots
" bugs, consider merge his code and fixes the bugs
let g:showmarks_enable = 1
let g:showmarks_include = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:showmarks_ignore_type = 'hqm' " Ignore help, quickfix, non-modifiable buffers
" Hilight lower & upper marks
let g:showmarks_hlline_lower = 1
let g:showmarks_hlline_upper = 0

" highlight clear  ShowMarksHLl " This group is used to highlight all the lowercase marks.
" highlight clear  ShowMarksHLu " This group is used to highlight all the uppercase marks.
" highlight clear  ShowMarksHLo " This group is used to highlight all other marks.
" highlight clear  ShowMarksHLm " This group is used when multiple marks are on the same line.

Plugin 'MattesGroeger/vim-bookmarks',     { 'on_map' : '<Plug>Bookmark','on_cmd' : 'BookmarkShowAll',}
let g:bookmark_no_default_key_mappings = 1
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
nmap mb <Plug>BookmarkToggle
nmap mi <Plug>BookmarkAnnotate
nmap ma <Plug>BookmarkShowAll
nmap mn <Plug>BookmarkNext
nmap mp <Plug>BookmarkPrev

" ex-visincr: invoke when select text and type ':II'
" ---------------------------------------------------
Plugin 'exvim/ex-visincr'

" searchcompl: invoke by /
" ---------------------------------------------------
Plugin 'exvim/exsearchcompl'

" vim-color-solarized
" ---------------------------------------------------
Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'
let g:gruvbox_italic = get(g:, 'gruvbox_italic', 0)
" }

" lua {
" Plugin 'xolox/vim-misc'  " required by lua.vim
" Plugin 'xolox/vim-lua-ftplugin'  " Lua file type plug-in for the Vim text editor
Plugin 'binesiyu/vim-lua-ftplugin'  " Lua file type plug-in for the Vim text editor
Plugin 'tbastos/vim-lua'
let g:lua_define_completefunc = 0
let g:lua_define_omnifunc = 0
let g:lua_define_completion_mappings = 0
let lua_version = 5
let lua_subversion = 1
" }

" debugger {
" Plugin 'binesiyu/vdebug',{'merged': 0}
" let g:vdebug_options= {
"             \    "port" : 9000,
"             \    "timeout" : 60,
"             \    "on_close" : "detach",
"             \    "break_on_open" : 1,
"             \    "path_maps" : {},
"             \    "server" : "",
"             \    "debug_window_level" : 0,
"             \    "background_listener" : 1,
"             \    "debug_file_level" : 8,
"             \    "debug_file" : "~/vdebug.log",
"             \    "continuous_mode" : 1,
"             \    "watch_window_style" : "expanded",
"             \    "marker_default" : "⬦",
"             \    "marker_closed_tree" : "▸",
"             \    "marker_open_tree" : "▾"
"             \}

" }

" git {
" Plugin 'tpope/vim-abolish.git'
Plugin 'junegunn/gv.vim',{ 'on_cmd' : ['GV']}
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'lambdalisue/gina.vim',{ 'on_cmd' : 'Gina'}

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_max_signs = 10000

" nnoremap <silent> <leader>gs :Gina status<CR>
nnoremap <silent> <leader>gi :Gina status<CR>
nnoremap <silent> <leader>gS :Gina add %<CR>
nnoremap <silent> <leader>gU :Gina reset -q %<CR>
nnoremap <silent> <leader>gc :Gina commit<CR>
nnoremap <silent> <leader>gp :Gina push<CR>
nnoremap <silent> <leader>gd :Gina diff<CR>
nnoremap <silent> <leader>gA :Gina add .<CR>
nnoremap <silent> <leader>gb :Gina blame<CR>
nnoremap <silent> <leader>gV :GV!<CR>
nnoremap <silent> <leader>gv :GV<CR>
" }

" vim-airline {
" ---------------------------------------------------
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

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


" exvim {
Plugin 'binesiyu/exvim'

" ex-config:
" ---------------------------------------------------
" nnoremap <unique> <leader>ve :call exconfig#edit_cur_vimentry ()<CR>

" ex-utility:
" ---------------------------------------------------
" nnoremap <unique> <silent> <Leader>bd :EXbd<CR>
" nnoremap <unique> <silent> <Leader>l :EXbn<CR>
" nnoremap <unique> <silent> <Leader>h :EXbp<CR>
" nnoremap <unique> <silent> <C-Tab> :EXbalt<CR>
" nnoremap <unique> <silent> <Leader><Tab> :EXsw<CR>
" nmap <unique> <silent> <Leader><Esc> :EXgp<CR><ESC>

" ex-gsearch
" ---------------------------------------------------

let g:ex_gsearch_ignore_case = 0
call exgsearch#register_hotkey( 100, 0, '<leader>gs', ":EXGSearchToggle<CR>", 'Toggle global search window.' )
call exgsearch#register_hotkey( 101, 0, '<leader>gg', ":EXGSearchCWord<CR>", 'Search current word.' )
call exgsearch#register_hotkey( 102, 0, '<leader><S-f>', ":GSW ", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 102, 0, '<leader>gf', ":GSW <C-R>*<CR> ", 'Shortcut for :GSW' )

" ex-tagselect
" ---------------------------------------------------

call extags#register_hotkey( 100, 0, '<leader>ts', ":EXTagsToggle<CR>", 'Toggle tag select window.' )
call extags#register_hotkey( 101, 0, '<leader>tt', ":EXTagsCWord<CR>", 'Tag select current word.' )
"nnoremap <unique> <leader>] :exec 'ts ' . expand('<cword>')<CR>

" ex-symbol
" ---------------------------------------------------
call exsymbol#register_hotkey( 100, 0, '<leader>sl', ":EXSymbolList<CR>", 'List all symbols.' )
call exsymbol#register_hotkey( 101, 0, '<leader>st', ":EXSymbolToggle<CR>", 'Open symbols window.' )
call exsymbol#register_hotkey( 102, 0, '<leader>ss', ":EXSymbolCWord<CR>", 'List symbols contains current word.' )

if has('gui_running')
    if has ('mac')
        call exsymbol#register_hotkey( 102, 0, 'Ò', ":EXSymbolList<CR>:redraw<CR>/", 'List all symbols and stay in search mode.' )
    else
        call exsymbol#register_hotkey( 102, 0, '<M-L>', ":EXSymbolList<CR>:redraw<CR>/", 'List all symbols and stay in search mode.' )
    endif
endif
let g:ex_symbol_select_cmd = 'TS'

" ex-cscope
" ---------------------------------------------------
" call excscope#register_hotkey( 100, 0, '<leader>ds', ":EXCSToggle<CR>", 'Toggle cscope window.' )
" call excscope#register_hotkey( 101, 0, '<leader>dc', ":CSDD<CR>", 'Find functions called by this function' )
" call excscope#register_hotkey( 102, 0, '<leader>dd', ":CSCD<CR>", 'Find functions calling by this function' )
" call excscope#register_hotkey( 103, 0, '<leader>di', ":CSID<CR>", 'Find files #including this file' )
" call excscope#register_hotkey( 104, 0, '<leader>dg', ":CSGD<CR>", 'Find this definition' )

" ex-qfix
" ---------------------------------------------------
" call exqfix#register_hotkey( 100, 0, '<leader>qf', ":EXQFixToggle<CR>", 'Toggle quickfix window.' )
" call exqfix#register_hotkey( 101, 0, '<leader>qq', ":EXQFixPaste<CR>", 'Open quickfix window and paste error list from register *.' )
" }

" haskell {
Plugin 'dag/vim2hs'
let g:haskell_conceal = 0
let g:haskell_conceal_enumerations = 0
let g:haskell_tabular = 0

" Syntax Highlighting and Indentation for Haskell and Cabal
" Plugin 'neovimhaskell/haskell-vim'

" highlight
" Plugin 'travitch/hasksyn'

" unicode display
" Plugin 'Twinside/vim-haskellConceal'
Plugin 'Twinside/vim-haskellFold'

" hoogle
Plugin 'Twinside/vim-hoogle'
Plugin 'lukerandall/haskellmode-vim'
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
Plugin 'eagletmt/neco-ghc'
Plugin 'eagletmt/ghcmod-vim'

" stylish
Plugin 'nbouscal/vim-stylish-haskell'
" Use stylish haskell instead of par for haskell buffers
autocmd FileType haskell let &formatprg="stylish-haskell"
autocmd FileType haskell compiler ghc

" haskell repl
" Plugin 'adinapoli/cumino'
" Plugin 'bitc/vim-hdevtools'
" if OSX()
    " let g:cumino_default_terminal = "iTerm"
" else

" endif

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
Plugin 'hsanson/vim-winmode'
nmap <leader>ww <Plug>WinModeStart
let g:win_mode_default ='resize'

Plugin 'binesiyu/vim-quick-community'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'
" }

" buffer {
Plugin 'moll/vim-bbye'
Plugin 'vim-scripts/BufOnly.vim'
nnoremap <Leader>bd :Bdelete<CR>
" nnoremap <F4> :Bdelete<CR>
" nnoremap <F5> :edit ++ff=dos<CR>

Plugin 'binesiyu/vim-tweak'

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

call dein#end()
" call dein#save_state()
" endif

" vundle#end }}
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

" setup back and swap directory
" let data_dir = $HOME.'/.data/'
" let backup_dir = data_dir . 'backup'
" let swap_dir = data_dir . 'swap'
" if finddir(data_dir) == ''
    " silent call mkdir(data_dir)
" endif
" if finddir(backup_dir) == ''
    " silent call mkdir(backup_dir)
" endif
" if finddir(swap_dir) == ''
    " silent call mkdir(swap_dir)
" endif
" unlet backup_dir
" unlet swap_dir
" unlet data_dir

set backupdir=$HOME/.data/backup " where to put backup file
set directory=$HOME/.data/swap " where to put swap file
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

" set default guifont {{
if !LINUX()
if has('gui_running')
    if has("mac") || has("gui_macvim")
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
        set guifontwide=YaHei\ Consolas\ Hybrid:h12
    else
        augroup ex_gui_font
            " check and determine the gui font after GUIEnter.
            " NOTE: getfontname function only works after GUIEnter.
            au!
            au GUIEnter * call s:set_gui_font()
        augroup END

        " set guifont
        function! s:set_gui_font()
            if has('gui_gtk2')
                if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
                elseif getfontname( 'DejaVu Sans Mono' ) != ''
                    set guifont=DejaVu\ Sans\ Mono\ 12
                else
                    set guifont=Luxi\ Mono\ 12
                endif
            elseif has('x11')
                " Also for GTK 1
                set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
            elseif OSX()
                if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
                elseif getfontname( 'DejaVu Sans Mono' ) != ''
                    set guifont=DejaVu\ Sans\ Mono:h12
                endif
                if getfontname( 'YaHei Consolas Hybrid' ) != ''
                    set guifontwide=YaHei\ Consolas\ Hybrid:h12
                endif
            elseif WINDOWS()
                if getfontname( 'DejaVu Sans Mono for Powerline' ) != ''
                    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h11:cANSI:qDRAFT
                elseif getfontname( 'DejaVu Sans Mono' ) != ''
                    set guifont=DejaVu\ Sans\ Mono:h11:cANSI
                elseif getfontname( 'Consolas' ) != ''
                    set guifont=Consolas:h11:cANSI " this is the default visual studio font
                else
                    set guifont=Lucida_Console:h11:cANSI
                endif
            endif
        endfunction
    end
endif
endif
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

    " DISABLE
    " if WINDOWS()
    "     au GUIEnter * simalt ~x " Maximize window when enter vim
    " else
    "     " TODO: no way right now
    " endif
    " disable menu & toolbar
    set guioptions-=T           " Remove the toolbar
    set guioptions-=m           " Remove the menu
    set guioptions-=L           " Remove the
    set guioptions-=b           " Remove the
    set guioptions-=r           " Remove the
    set gcr=a:block-blinkon0    "noblock"
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

" official diff settings
set diffexpr=g:MyDiff()
function! g:MyDiff()
    let opt = '-a --binary -w '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    silent execute '!' .  'diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
endfunction

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=
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
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set noerrorbells visualbell t_vb=
"}}
" }

" Auto Command {

" ------------------------------------------------------------------
" Desc: Only do this part when compiled with support for autocommands.
" ------------------------------------------------------------------

if has('autocmd')

    augroup ex
        au!

        " ------------------------------------------------------------------
        " Desc: Buffer
        " ------------------------------------------------------------------

        " when editing a file, always jump to the last known cursor position.
        " don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        au BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif
        au BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
        au BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
        au BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.

        " DISABLE {
        " NOTE: will have problem with exvim, because exvim use exES_CWD as working directory for tag and other thing
        " Change current directory to the file of the buffer ( from Script#65"CD.vim"
        " au   BufEnter *   execute ":lcd " . expand("%:p:h")
        " } DISABLE end

        " ------------------------------------------------------------------
        " Desc: file types
        " ------------------------------------------------------------------

        au FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
        au FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.

        " disable auto-comment for c/cpp, lua, javascript, c# and vim-script
        au FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
        au FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
        au FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
        au FileType lua set comments=f:--
        au FileType lua set foldmethod=indent

        " if edit python scripts, check if have \t. ( python said: the programme can only use \t or not, but can't use them together )
        au FileType python,coffee call s:check_if_expand_tab()
    augroup END

    function! s:check_if_expand_tab()
        let has_noexpandtab = search('^\t','wn')
        let has_expandtab = search('^    ','wn')

        "
        if has_noexpandtab && has_expandtab
            let idx = inputlist ( ['ERROR: current file exists both expand and noexpand TAB, python can only use one of these two mode in one file.\nSelect Tab Expand Type:',
                        \ '1. expand (tab=space, recommended)',
                        \ '2. noexpand (tab=\t, currently have risk)',
                        \ '3. do nothing (I will handle it by myself)'])
            let tab_space = printf('%*s',&tabstop,'')
            if idx == 1
                let has_noexpandtab = 0
                let has_expandtab = 1
                silent exec '%s/\t/' . tab_space . '/g'
            elseif idx == 2
                let has_noexpandtab = 1
                let has_expandtab = 0
                silent exec '%s/' . tab_space . '/\t/g'
            else
                return
            endif
        endif

        "
        if has_noexpandtab == 1 && has_expandtab == 0
            echomsg 'substitute space to TAB...'
            set noexpandtab
            echomsg 'done!'
        elseif has_noexpandtab == 0 && has_expandtab == 1
            echomsg 'substitute TAB to space...'
            set expandtab
            echomsg 'done!'
        else
            " it may be a new file
            " we use original vim setting
        endif
    endfunction
endif
" }

" Key Mappings {

" NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

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

" nnoremap <leader>/ :let @/=""<CR>
" DISABLE: though nohlsearch is standard way in Vim, but it will not erase the
"          search pattern, which is not so good when use it with exVim's <leader>r
"          filter method
" nnoremap <F8> :nohlsearch<CR>
" nnoremap <leader>/ :nohlsearch<CR>

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

" easy buffer navigation
" NOTE: if we already map to EXbn,EXbp. skip setting this
if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
    nnoremap <C-l> :bn<CR>
endif
if !hasmapto(':EXbp<CR>') && mapcheck('<C-h>','n') == ''
    noremap <C-h> :bp<CR>
endif

" easy diff goto
" noremap <C-k> [c
" noremap <C-j> ]c

" enhance '<' '>' , do not need to reselect the block after shift it.
vnoremap < <gv
vnoremap > >gv

" map Up & Down to gj & gk, helpful for wrap text edit
noremap <Up> gk
noremap <Down> gj

" TODO: I should write a better one, make it as plugin exvim/swapword
" VimTip 329: A map for swapping words
" http://vim.sourceforge.net/tip_view.php?tip_id=
" Then when you put the cursor on or in a word, press "\sw", and
" the word will be swapped with the next word.  The words may
" even be separated by punctuation (such as "abc = def").
nnoremap <silent> <leader>sw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<cr><c-o>

" Most prefer to toggle search highlighting rather than clear the current
" search results. To clear search highlighting rather than toggle it on
" and off, add the following to your .vimrc.before.local file:
" nmap <silent> <leader>/ :nohlsearch<CR>
" Map <Leader>ff to display all lines with keyword under cursor
" and ask which one to jump to
nmap <Leader>fw [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
nmap <Leader>bl :buffers<CR>:let nr = input("Which one: ")<Bar>exe "buffer " . nr<CR>
nnoremap <leader>ff :let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

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
nmap <Space> 4<C-e>
nmap <S-Space> 4<C-y>
"}

" fix colorscheme {

highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number
hi VertSplit ctermbg=NONE guibg=NONE
set fillchars+=vert:│
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

let g:edit_config_mapping='<leader>ve'
let g:apply_config_mapping='<leader>vr'
execute "noremap " . g:edit_config_mapping " :call EditVimrc13Config()<CR>"
execute "noremap " . g:apply_config_mapping . " :source $HOME/.vimrc<CR>"
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

" Navigate tabs
nnoremap tt  :tabnext<CR>
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tn  :tabnew<CR>
nnoremap tp  :tabprevious<CR>
nnoremap tc  :tabclose<CR>

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
