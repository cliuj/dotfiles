local g = vim.g
local opt = vim.opt
local opt_local = vim.opt_local
local map = vim.api.nvim_set_keymap

local home = os.getenv("HOME")

-- Load external plugins
dofile(home .. "/.config/nvim/lua/nvim-tree.lua")
dofile(home .. "/.config/nvim/lua/nvim-cmp.lua")
dofile(home .. "/.config/nvim/lua/nvim-autopairs.lua")
dofile(home .. "/.config/nvim/lua/lsp.lua")
dofile(home .. "/.config/nvim/lua/telescope-nvim.lua")

-- Performance settings
opt.lazyredraw = true
opt.ttimeoutlen = 10
opt.updatetime = 300

-- Set shell
opt.shell = "fish"

-- UI
g.t_Co = 256
g.syntax = "on"
g.termguicolors = true
opt.background = "dark"
opt.number = true

-- Cursor
opt.cursorline = true
opt.guicursor = "i:block"

-- Enable undo file
opt.undofile = true

-- Indentation
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true

-- Backspace Indentation
opt.backspace = {"indent", "eol", "start"}

-- Disable viminfo
opt.viminfo = ""
opt.viminfofile = "NONE"

-- Misc
opt.clipboard = "unnamedplus"
opt.scrolloff = 5
opt.ignorecase = true
opt.mouse = "a"
opt.backup = false
opt.swapfile = false
opt.cmdheight = 2

-- Splitting
opt.splitbelow = true
opt.splitright = true

-- Mappings
map('n', '<S-j>', '}', { noremap = true })
map('n', '<S-k>', '{', { noremap = true })
map('n', '<space>', '<C-W>', { noremap = true })
map('n', ';', ':', { noremap = true })
map('n', '<S-t>', ':sp | resize 30 | set nonumber | terminal <CR>', { noremap = true })
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

vim.cmd([[
  silent! colorscheme dark-meadow
  setglobal tabstop=4
  setglobal shiftwidth=4
  
  " Highlight colors for {} [] ()
  hi MatchParen cterm=NONE ctermfg=NONE ctermfg=000000
  
  " Disable auto commenting
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  
  " Hotkey to check highlight groups
  nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  filetype plugin on
]])
