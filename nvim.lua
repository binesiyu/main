
--packer
local vim = _G.vim
local execute = vim.api.nvim_command
local fn  = vim.fn
local cmd = vim.cmd
local o   = vim.o
local g   = vim.g
local empty = {}

local function isOSX()
    return 0 ~= fn.has('macunix')
end

local function isLinux()
    return 0 ~= fn.has('unix') and 0 == fn.has('macunix') and 0 == fn.has('win32unix')
end

local function isWindows()
    return 0 ~= fn.has('win32') or 0 ~= fn.has('win64') or 0 ~= fn.has('win16')
end

--global options
--
-- set default encoding to utf-8
o.fileencoding = "utf-8" -- The encoding written to file
-- " Let Vim use utf-8 internally, because many scripts require this
o.encoding = "utf-8"

-- " Windows has traditionally used cp1252, so it's probably wise to
-- " fallback into cp1252 instead of eg. iso-8859-15.
-- " Newer Windows files might contain utf-8 or utf-16 LE so we might
-- " want to try them first.
o.fileencodings = "ucs-bom,utf-8,gbk,gb2312,big5,iso-8859-15,utf-16le" -- The encoding written to file

g.mapleader = ","
g.maplocalleader= ","

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"

    local plugin_path = plugin_prefix .. plugin .. "/"
    --	print('test '..plugin_path)
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    --	print(ok, err, code)
    if ok then vim.cmd("packadd " .. plugin) end
    return ok, err, code
end

require("packer").startup(function(use)
    -- Packer can manage itself as an optional plugin
    use "wbthomason/packer.nvim"

    -- Telescope
    use {"nvim-lua/popup.nvim", opt = true}
    use {"nvim-lua/plenary.nvim", opt = true}
    use {"nvim-telescope/telescope.nvim", opt = true}
    use {"nvim-telescope/telescope-fzy-native.nvim", opt = true}
    use {"nvim-telescope/telescope-project.nvim", opt = true}

    require_plugin("popup.nvim")
    require_plugin("plenary.nvim")
    require_plugin("telescope.nvim")
    require_plugin('telescope-project.nvim')

    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
    require_plugin("nvim-treesitter")

    -- ui
    use {"mhinz/vim-startify", opt = true}
    require_plugin("vim-startify")

    -- colorscheme
    use {"morhetz/gruvbox", opt = true}

end)

cmd('filetype plugin indent on') -- filetype detection
cmd('syntax on') -- syntax highlighting

-- General

-- Default colorscheme setup
o.background = "dark"
cmd('colorscheme gruvbox')
--fix colorscheme
vim.cmd([[
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
"highlight clear CursorLineNr    " Remove highlight color from current line number
hi VertSplit ctermbg=NONE guibg=NONE
]])

o.timeout = false
o.backup = false -- make backup file and leave it around
o.swapfile  = false

-- set guifont
if isOSX() then
    o.guifont = "DejaVuSansMono YaHei NF:h12"
elseif isWindows() then
    o.guifont = "DejaVu Sans Mono for Powerline:h11:cANSI:qDRAFT"
else
    o.guifont = "DejaVu Sans Mono for Powerline 12"
end

-- Redefine the shell redirection operator to receive both the stderr messages and stdout messages
-- cmd('set shellredir=>%s 2>&1')
o.history=50 -- keep 50 lines of command line history
o.updatetime=1000 -- default = 4000
o.autoread  = true -- auto read same-file change ( better for vc/vim change )
o.maxmempattern=1000 -- enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)
o.mouse = "a" -- Enable your mouse

-- Variable settings ( set all )
o.matchtime=0 -- 0 second to show the matching paren ( much faster )
o.scrolloff=7 -- minimal number of screen lines to keep above and below the cursor

o.number = true -- set numbered lines
o.relativenumber = true -- set relative number
o.cursorline = true -- Enable highlighting of the current line
o.wrap = false -- do not wrap text

-- Vim UI
-- o.wildmode=list:longest,full
o.wildmenu = true -- turn on wild menu, try typing :h and press <Tab>
o.showcmd  = true-- display incomplete commands
o.cmdheight=1 -- 1 screen lines to use for the command-line
o.ruler  = true-- show the cursor position all the time
o.hidden  = true-- allow to change buffer without saving
o.shortmess = "aoOtTI" -- shortens messages to avoid 'press a key' prompt
o.lazyredraw  = true-- do not redraw while executing macros (much faster)
o.laststatus=2 -- always have status-line
o.titlestring= '%t (%{expand("%:p:.:h")}/)'
cmd('set display+=lastline') -- for easy browse last line with wrap text
cmd('set completeopt-=preview')

-- Text edit {{
o.showfulltag = true -- show tag with function protype.
o.autoindent = true -- autoindent
o.smartindent = true -- smartindent
o.backspace='indent,eol,start' -- allow backspacing over everything in insert mode
-- indent options
-- see help cinoptions-values for more details
cmd('set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30')

o.cindent  = true
o.shiftwidth=4 -- set cindent on to autoinent when editing c/c++ file, with 4 shift width
o.tabstop=4 -- set tabstop to 4 characters
o.expandtab = true-- set expandtab on, the tab will be change to space automaticaly
o.ve='block' -- in visual block mode, cursor can be positioned where there is no actual character

cmd('set sessionoptions -=folds')

-- Fold text {{
o.foldmethod='marker'
o.foldmarker='{,}'
o.foldlevel=9999
o.diffopt='filler,context:9999'

o.showmatch = true-- show matching paren
o.incsearch = true-- do incremental searching
o.hlsearch = true-- highlight search terms
o.ignorecase = true-- set search/replace pattern to ignore case
o.smartcase = true-- set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

-- set this to use id-utils for global search
o.grepprg='lid -Rgrep -s'
o.grepformat='%f:%l:%m'

-- window op
o.listchars='tab:› ,trail:•,extends:↷,precedes:↶,nbsp:.' -- Highlight problematic whitespace
o.errorbells  = false
o.visualbell = true
o.t_vb=""
o.fillchars='vert:│,fold:·'
cmd('set nrformats-=octal')
o.splitbelow = true

-- clipboard
if 1 == fn.has('clipboard') then
    if 1 == fn.has('unnamedplus') then --When possible use + register for copy-paste
        o.clipboard='unnamedplus,unnamed'
    else         -- On mac and Windows, use * register for copy-paste
        o.clipboard='unnamed'
    end
end

-- enable true color
o.termguicolors = true -- set term gui colors most terminals support this

local function defineGroup(group_name,definition)
    vim.cmd('augroup ' .. group_name)
    vim.cmd('autocmd!')

    for _, def in pairs(definition) do
        local command = table.concat(vim.tbl_flatten {'autocmd', def}, ' ')
        vim.cmd(command)
    end

    vim.cmd('augroup END')
end
-- autocmd
local function defineGroupAll(definitions) -- {{{1
    -- Create autocommand groups based on the passed definitions
    --
    -- The key will be the name of the group, and each definition
    -- within the group should have:
    --    1. Trigger
    --    2. Pattern
    --    3. Text
    -- just like how they would normally be defined from Vim itself
    for group_name, definition in pairs(definitions) do
        defineGroup(group_name,definition)
    end
end

local Ex = {
    {'BufNewFile,BufEnter', '*', 'set cpoptions+=d'}, -- NOTE: ctags find the tags file from the current path instead of the path of currect file

    -- when editing a file, always jump to the last known cursor position.
    -- don't do it when the position is invalid or when inside an event handler
    -- (happens when dropping a file on gvim).
    {'BufReadPost', '*', [[if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif]]},

    {'FileType','text','setlocal textwidth=80'},--for all text files set 'textwidth' to 78 characters.
    {'FileType','c,cpp,cs,swig','set nomodeline'},-- this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
    -- disable auto-comment for c/cpp, lua, javascript, c# and vim-script
    {'FileType','c,cpp,java,javascript','set comments=sO:* -,mO:*  ,exO:*/,s1:/*,mb:*,ex:*/,f://'},
    {'FileType','vim set','comments=sO:" -,mO:"  ,eO:"",f:"'},
}

if 1 == fn.has("gui_vimr") then
    table.insert(Ex,{'FocusGained', '*', 'checktime'})
end

defineGroupAll({
    CursorLine = {
        {'VimEnter,WinEnter,BufWinEnter', '*', 'setlocal cursorline'},
        {'WinLeave', '*', 'setlocal nocursorline'},
    },
    Ex = Ex,
})

-- Key Mappings
--
local api = vim.api
local keymap = api.nvim_set_keymap
local noremap_cfg = {noremap = true}
local noremap_silent = {noremap = true,silent = true}
local function map(key,mapcmd,mode,opt)
    keymap(mode or "",key,mapcmd or "", opt or empty)
end

-- Don't use Ex mode, use Q for formatting
-- map Q gq
map('Q')
map(';',':','n',noremap_cfg)
map(';',':','v',noremap_cfg)

-- Swap implementations of ` and ' jump to markers
map("'",'`','n',noremap_cfg)
map("`","'",'n',noremap_cfg)

-- copy folder path to clipboard, foo/bar/foobar.c => foo/bar/
map("<leader>y1",[[:let @*=fnamemodify(bufname('%'),":p:h")<CR>]],'n',noremap_silent)

-- copy file name to clipboard, foo/bar/foobar.c => foobar.c
map("<leader>y2",[[:let @*=fnamemodify(bufname('%'),":p:t")<CR>]],'n',noremap_silent)

-- copy full path to clipboard, foo/bar/foobar.c => foo/bar/foobar.c
map("<leader>y3",[[:let @*=fnamemodify(bufname('%'),":p")<CR>]],'n',noremap_silent)

-- When pressing <leader>cd switch to the directory of the open buffer
map('<Leader>cd',":cd %:p:h<CR>:pwd<CR>")

-- Select blocks after indenting
map('<','<gv','x',noremap_cfg)
map('>','>gv|','x',noremap_cfg)

map('>','>>_','n',noremap_cfg)
map('<','<<_','n',noremap_cfg)
-- enhance '<' '>' , do not need to reselect the block after shift it.
map('>','>gv','v',noremap_cfg)
map('<','<gv','v',noremap_cfg)

--Use tab for indenting in visual mode
map('<Tab>','>gv|','x',noremap_cfg)
map('<S-Tab>','<gv','x',noremap_cfg)

map('<Space>','<C-e>','n')
map('<S-Space>','<C-y>','n')

map('Y','y$','n',noremap_cfg)

map('<F2>',':set wrap!<BAR>set wrap?<CR>')
map('<F4>',':set relativenumber!<BAR>set relativenumber?<CR>')
map('<F11>',':set cursorline!<BAR>set nocursorline?<CR>')
map('<F12>',':set cursorcolumn!<BAR>set nocursorcolumn?<CR>')

-- register /
vim.cmd([[
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
]])

-- edit vimrc
vim.cmd([[
function! ExpandFilenameAndExecute(command, file)
    execute a:command . " " . expand(a:file, ":p")
endfunction

function! EditVimrc13Config()
    call ExpandFilenameAndExecute("tabedit", "$HOME/.vim-self/.vimrc")
    execute bufwinnr(".vimrc") . "wincmd w"
endfunction

noremap <Leader>ev :call EditVimrc13Config()<CR>
]])
-- Strip whitespace
vim.cmd([[
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

nnoremap <leader>ws :call StripTrailingWhitespace()<CR>
]])

-- searching
-- Visual mode pressing
vim.cmd([[
function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>n :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> <leader>h :<C-u>call VisualSelection()<CR>:set hls<CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
vnoremap <silent> <leader>N :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
]])

map('<leader>h',[[:let @/='\<\C<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>]],'n',noremap_cfg)
map('<leader>n','*','n')
map('<leader>N','#','n')
map('<F8>',':let @/=""<CR>','n',noremap_cfg)
map('<leader>/',':let @/=""<CR>','n',noremap_cfg)
-- Navigation in command line
map('<C-a>','<Home>','c',noremap_cfg)
map('<C-b>','<Left>','c',noremap_cfg)
map('<C-f>','<Right>','c',noremap_cfg)
map('w!!','%!sudo tee > /dev/null %','c',noremap_cfg)
-- Fast saving
map('<C-s>',':<C-u>w<CR>','n',noremap_cfg)
map('<C-s>',':<C-u>w<CR>','v',noremap_cfg)
map('<C-s>','<C-u>w<CR>','c',noremap_cfg)
-- Visually select the text that was last edited/pasted
map('gV','`[v`]','',noremap_cfg)

--fold
map('<leader>f0',':set foldlevel=0<CR>','',noremap_cfg)

for i =1,9 do
    map('<leader>t' .. i, i .. 'gt','n',noremap_cfg)
    map('<leader>' .. i, i .. '<C-W>W','n',noremap_cfg)
    map('<leader>f' .. i, ':set foldlevel=' .. i .. '<CR>','',noremap_cfg)
end

map('<leader>if',[[:exec 'normal ,hciw' . expand('%:t:r:r:r') . "\e"<CR>]],'n',noremap_cfg)
map('<leader>ip',':normal "_cib*','n',noremap_cfg)

--Terminal
vim.cmd([[
exe 'tnoremap <silent><C-Right> <C-\><C-n>:<C-u>wincmd l<CR>'
exe 'tnoremap <silent><C-Left>  <C-\><C-n>:<C-u>wincmd h<CR>'
exe 'tnoremap <silent><C-Up>    <C-\><C-n>:<C-u>wincmd k<CR>'
exe 'tnoremap <silent><C-Down>  <C-\><C-n>:<C-u>wincmd j<CR>'
exe 'tnoremap <silent><M-Left>  <C-\><C-n>:<C-u>bprev<CR>'
exe 'tnoremap <silent><M-Right>  <C-\><C-n>:<C-u>bnext<CR>'
exe 'tnoremap <silent><esc>     <C-\><C-n>'
]])
--tab navigation
map('<leader>f0',':set foldlevel=0<CR>','n',noremap_cfg)
map('<leader>tj',':tabfirst<CR>','n',noremap_cfg)
map('<leader>th',':tabnext<CR>','n',noremap_cfg)
map('<leader>tl',':tabprev<CR>','n',noremap_cfg)
map('<leader>tk',':tablast<CR>','n',noremap_cfg)
map('<leader>tn',':tabnew<CR>','n',noremap_cfg)
map('<leader>tc',':tabclose<CR>','n',noremap_cfg)
map('<leader>tm',':tabm<Space>','n',noremap_cfg)
map('<leader>td',':tabclose<CR>','n',noremap_cfg)
map('<leader>to',':tabonly<CR>','n',noremap_cfg)
map('H','gT','n',noremap_cfg)
map('L','gt','n',noremap_cfg)

g.Lasttab = 1
g.Lasttab_backup = 1

defineGroup("TabNam",{
    {'TabLeave', '*', 'let g:Lasttab_backup = g:Lasttab | let g:Lasttab = tabpagenr()'},
    {'TabClosed', '*', 'let g:Lasttab = g:Lasttab_backup'},
})

map('<Leader>tp',':exe "tabn " . g:Lasttab<cr>','n',noremap_silent)

cmd([[cabbr <expr> %% expand('%:p:h')]])
