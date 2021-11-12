require('telescope').setup{
  pickers = {
    find_files = {
      theme = "dropdown",
    }
  }
}

-- Mappings
local map = vim.api.nvim_set_keymap
map('n', '<C-g>', ':Telescope find_files find_command=fd,--hidden<CR>', { noremap = true })
map('n', '<C-b>', ':Telescope buffers<CR>', { noremap = true })
map('n', '<C-f>', ':Telescope live_grep <CR>', { noremap = true })
