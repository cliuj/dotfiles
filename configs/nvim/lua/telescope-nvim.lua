require('telescope').setup{}

-- Mappings
local map = vim.api.nvim_set_keymap
map('n', '<C-g>', ':Telescope find_files find_command=fd<CR>', { noremap = true })
map('n', '<C-f>', ':Telescope live_grep <CR>', { noremap = true })
