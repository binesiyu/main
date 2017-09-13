
" ex-config:
" ---------------------------------------------------
Plugin 'exvim/ex-config'
" nnoremap <unique> <leader>ve :call exconfig#edit_cur_vimentry ()<CR>

" ex-utility:
" ---------------------------------------------------
Plugin 'exvim/ex-utility'

nnoremap <unique> <silent> <Leader>bd :EXbd<CR>
nnoremap <unique> <silent> <Leader>l :EXbn<CR>
nnoremap <unique> <silent> <Leader>h :EXbp<CR>
nnoremap <unique> <silent> <C-Tab> :EXbalt<CR>
nnoremap <unique> <silent> <Leader><Tab> :EXsw<CR>
nmap <unique> <silent> <Leader><Esc> :EXgp<CR><ESC>

" ex-aftercolor
" ---------------------------------------------------
Plugin 'exvim/ex-aftercolors'

" ex-vimentry
" ---------------------------------------------------
Plugin 'exvim/ex-vimentry'

" ex-project
" ---------------------------------------------------
Plugin 'exvim/ex-project'

" ex-gsearch
" ---------------------------------------------------
Plugin 'exvim/ex-gsearch'

let g:ex_gsearch_ignore_case = 0
call exgsearch#register_hotkey( 100, 0, '<leader>gs', ":EXGSearchToggle<CR>", 'Toggle global search window.' )
call exgsearch#register_hotkey( 101, 0, '<leader>gg', ":EXGSearchCWord<CR>", 'Search current word.' )
call exgsearch#register_hotkey( 102, 0, '<leader><S-f>', ":GSW ", 'Shortcut for :GSW' )
call exgsearch#register_hotkey( 102, 0, '<leader>gf', ":GSW <C-R>*<CR> ", 'Shortcut for :GSW' )

" ex-tagselect
" ---------------------------------------------------
Plugin 'exvim/ex-tags'

call extags#register_hotkey( 100, 0, '<leader>ts', ":EXTagsToggle<CR>", 'Toggle tag select window.' )
call extags#register_hotkey( 101, 0, '<leader>tt', ":EXTagsCWord<CR>", 'Tag select current word.' )
" DISABLE: nnoremap <unique> <leader>] :exec 'ts ' . expand('<cword>')<CR>

" ex-symbol
" ---------------------------------------------------
Plugin 'exvim/ex-symbol'

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
Plugin 'exvim/ex-cscope'

call excscope#register_hotkey( 100, 0, '<leader>ds', ":EXCSToggle<CR>", 'Toggle cscope window.' )
call excscope#register_hotkey( 101, 0, '<leader>dc', ":CSDD<CR>", 'Find functions called by this function' )
call excscope#register_hotkey( 102, 0, '<leader>dd', ":CSCD<CR>", 'Find functions calling by this function' )
call excscope#register_hotkey( 103, 0, '<leader>di', ":CSID<CR>", 'Find files #including this file' )
call excscope#register_hotkey( 104, 0, '<leader>dg', ":CSGD<CR>", 'Find this definition' )

" ex-qfix
" ---------------------------------------------------
Plugin 'exvim/ex-qfix'

call exqfix#register_hotkey( 100, 0, '<leader>qf', ":EXQFixToggle<CR>", 'Toggle quickfix window.' )
call exqfix#register_hotkey( 101, 0, '<leader>qq', ":EXQFixPaste<CR>", 'Open quickfix window and paste error list from register *.' )

" ex-hierarchy
" ---------------------------------------------------
Plugin 'exvim/ex-hierarchy'

" nnoremap <unique> <leader>hv :EXHierarchyCWord<CR>

" ex-taglist: invoke by <F4>
" ---------------------------------------------------
" Plugin 'exvim/ex-taglist'

" F4:  Switch on/off TagList
" nnoremap <unique> <silent> <F4> :TlistToggle<CR>

" let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool 
" let Tlist_Show_One_File = 1 " Displaying tags for only one file~
" let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself 
" let Tlist_Use_Right_Window = 1 " split to the right side of the screen 
" let Tlist_Sort_Type = "order" " sort by order or name
" let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
" let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
" let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
" let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
" let Tlist_Close_On_Select = 0 " Close the taglist window when a file or tag is selected.
" let Tlist_BackToEditBuffer = 0 " If no close on select, let the user choose back to edit buffer or not
" let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
" let Tlist_WinWidth = 40
" let Tlist_Compact_Format = 1 " do not show help
" let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'
" very slow, so I disable this
" let Tlist_Process_File_Always = 1 " To use the :TlistShowTag and the :TlistShowPrototype commands without the taglist window and the taglist menu, you should set this variable to 1.
":TlistShowPrototype [filename] [linenumber]

" add javascript language
" let tlist_javascript_settings = 'javascript;v:global variable:0:0;c:class;p:property;m:method;f:function;r:object'
" add hlsl shader language
" let tlist_hlsl_settings = 'c;d:macro;g:enum;s:struct;u:union;t:typedef;v:variable;f:function'
" add actionscript language
" let tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'

" DISABLE: use tlist instead
" " exvim/ex-tagbar: invoke by <F4>
" " ---------------------------------------------------
" Plugin 'exvim/ex-tagbar'

" nnoremap <unique> <silent> <F4> :TagbarToggle<CR>

" let g:tagbar_sort = 0
" let g:tagbar_map_preview = '<CR>'
" if has('gui_running')
"     let g:tagbar_map_close = '<Esc>' 
" else
"     let g:tagbar_map_close = '<leader><Esc>' 
" endif
" let g:tagbar_map_zoomwin = '<Space>' 
" let g:tagbar_zoomwidth = 80
" let g:tagbar_autofocus = 1
" let g:tagbar_iconchars = ['+', '-']

" " use command ':TagbarGetTypeConfig lang' change your settings 
" let g:tagbar_type_javascript = {
"     \ 'ctagsbin': 'ctags',
"     \ 'kinds' : [
"         \ 'v:global variables:0:0',
"         \ 'c:classes',
"         \ 'p:properties:0:0',
"         \ 'm:methods',
"         \ 'f:functions',
"         \ 'r:object',
"     \ ],
" \ }
" let g:tagbar_type_c = {
"     \ 'kinds' : [
"         \ 'd:macros:0:0',
"         \ 'p:prototypes:0:0',
"         \ 'g:enums',
"         \ 'e:enumerators:0:0',
"         \ 't:typedefs:0:0',
"         \ 's:structs',
"         \ 'u:unions',
"         \ 'm:members:0:0',
"         \ 'v:variables:0:0',
"         \ 'f:functions',
"     \ ],
" \ }
" let g:tagbar_type_cpp = {
"     \ 'kinds' : [
"         \ 'd:macros:0:0',
"         \ 'p:prototypes:0:0',
"         \ 'g:enums',
"         \ 'e:enumerators:0:0',
"         \ 't:typedefs:0:0',
"         \ 'n:namespaces',
"         \ 'c:classes',
"         \ 's:structs',
"         \ 'u:unions',
"         \ 'f:functions',
"         \ 'm:members:0:0',
"         \ 'v:variables:0:0',
"     \ ],
" \ }


" ex-autocomplpop: invoke when you input text
" ---------------------------------------------------
" Plugin 'exvim/ex-autocomplpop'

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

highlight clear  ShowMarksHLl " This group is used to highlight all the lowercase marks.
highlight clear  ShowMarksHLu " This group is used to highlight all the uppercase marks.
highlight clear  ShowMarksHLo " This group is used to highlight all other marks.
highlight clear  ShowMarksHLm " This group is used when multiple marks are on the same line.

" ex-visincr: invoke when select text and type ':II'
" ---------------------------------------------------
Plugin 'exvim/ex-visincr'

" ex-matchit: invoke by %
" ---------------------------------------------------
Plugin 'exvim/ex-matchit'

" ex-easyhl:
" ---------------------------------------------------
Plugin 'exvim/ex-easyhl'
let g:easyhl_no_mappings = 1 
nnoremap <unique> <silent> <leader>j1 :EasyhlWord 1<CR>
nnoremap <unique> <silent> <leader>j2 :EasyhlWord 2<CR>
nnoremap <unique> <silent> <leader>j3 :EasyhlWord 3<CR>
nnoremap <unique> <silent> <leader>j4 :EasyhlWord 4<CR>

vnoremap <unique> <silent> <leader>j1 :EasyhlRange 1<CR>
vnoremap <unique> <silent> <leader>j2 :EasyhlRange 2<CR>
vnoremap <unique> <silent> <leader>j3 :EasyhlRange 3<CR>
vnoremap <unique> <silent> <leader>j4 :EasyhlRange 4<CR>

nnoremap <unique> <silent> <leader>j0 :EasyhlCancel 0<CR>

nnoremap <unique> <silent> <Leader>k0 :EasyhlCancel 0<CR>
nnoremap <unique> <silent> <Leader>k1 :EasyhlCancel 1<CR>
nnoremap <unique> <silent> <Leader>k2 :EasyhlCancel 2<CR>
nnoremap <unique> <silent> <Leader>k3 :EasyhlCancel 3<CR>
nnoremap <unique> <silent> <Leader>k4 :EasyhlCancel 4<CR>

" searchcompl: invoke by /
" ---------------------------------------------------
Plugin 'exvim/ex-searchcompl'

" ex-colorschemes
" ---------------------------------------------------
Plugin 'exvim/ex-colorschemes'

" vim-color-solarized
" ---------------------------------------------------
Plugin 'altercation/vim-colors-solarized'
" c-lang {{{

" ex-cref: invoke by <leader>cr
" ---------------------------------------------------
Plugin 'exvim/ex-cref'

" this is modified for default c syntax highlight settings 
" make it don't highlight error pattern
let c_gnu = 1
let c_no_curly_error = 1
let c_no_bracket_error = 1

"}}}
" only supoort in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

