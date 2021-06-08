
--packer
local vim = _G.vim
local execute = vim.api.nvim_command
local fn  = vim.fn
local cmd = vim.cmd
local o   = vim.o
local g   = vim.g

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
cmd('let g:nvcode_termcolors=256')
cmd('colorscheme gruvbox')

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
