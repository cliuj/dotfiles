vim.cmd([[
  try
    colorscheme dark-meadow
  catch
    silent! colorscheme industry
  endtry

  " Highlight colors for {} [] ()
  hi MatchParen cterm=NONE ctermfg=NONE ctermfg=000000

  " Disable auto commenting
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]])

local g = vim.g
local opt = vim.opt
local opt_local = vim.opt_local
local map = vim.api.nvim_set_keymap

local home = os.getenv("HOME")

-- Map leader to space
g.mapleader = ' '

-- Load external plugins
dofile(home .. "/.config/nvim/lua/nvim-tree.lua")
dofile(home .. "/.config/nvim/lua/telescope-nvim.lua")
dofile(home .. "/.config/nvim/lua/floaterm.lua")
dofile(home .. "/.config/nvim/lua/coc.lua")
dofile(home .. "/.config/nvim/lua/vimtex.lua")

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
opt_local.expandtab = true
opt_local.smarttab = true
opt_local.autoindent = true

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
opt.wrap = false
opt.swapfile = false
opt.cmdheight = 2

-- Splitting
opt.splitbelow = true
opt.splitright = true

-- Mappings
map('n', '<S-j>', '}', { noremap = true })
map('n', '<S-k>', '{', { noremap = true })
map('n', ';', ':', { noremap = true })
for i = 1, 9 do
  map('n', '<Leader>' .. i, i .. 'gt', { noremap = true })
end
map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
-- Explicitly map Space to C-W (leader) for pane switching
map('n', '<space>', '<C-W>', { noremap = true })
-- Open a split below terminal
map('n', '<S-t>', ':sp | resize 20 | set nonumber | terminal <CR>', { noremap = true })

vim.cmd([[
  " Hotkey to check highlight groups
  nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

  filetype on
  filetype plugin on
]])
