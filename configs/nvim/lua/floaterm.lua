local map = vim.api.nvim_set_keymap
local g = vim.g

g.floaterm_autoinsert = false
g.floaterm_autohide = 1
g.floaterm_shell = "fish"

map('n', '<S-t>', ':FloatermNew<CR>', { noremap = true })
map('n', '<Leader>t', ':FloatermToggle<CR>', { noremap = true })
map('t', '<Leader>t', '<C-\\><C-n>:FloatermToggle<CR>', { noremap = true })
map('n', 'tt', ':FloatermNext<CR>', { noremap = true })
map('n', 'tT', ':FloatermPrev<CR>', { noremap = true })
map('n', 'tx', ':FloatermKill<CR>', { noremap = true })
map('n', 'tX', ':FloatermKill!<CR>', { noremap = true })
map('n', 't;', ':FloatermSend ', { noremap = true })
