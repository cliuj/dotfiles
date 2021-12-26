local map = vim.api.nvim_set_keymap
local g = vim.g

g.floaterm_autoinsert = false
g.floaterm_autohide = 1
g.floaterm_shell = "fish"

map('n', 'tt', ':FloatermToggle<CR>', { noremap = true })
map('n', 'tn', ':FloatermNew<CR>', { noremap = true })
map('n', 'th', ':FloatermHide<CR>', { noremap = true })
map('n', 'ts', ':FloatermHide<CR>', { noremap = true })
map('n', 't.', ':FloatermNext<CR>', { noremap = true })
map('n', 't,', ':FloatermPrev<CR>', { noremap = true })
map('n', 'tx', ':FloatermKill<CR>', { noremap = true })
map('n', 'tX', ':FloatermKill!<CR>', { noremap = true })
map('n', 't;', ':FloatermSend ', { noremap = true })
