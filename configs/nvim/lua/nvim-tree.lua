require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = true,
  auto_close          = true,
  open_on_tab         = true,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  hijack_cursor       = false,
  update_cwd          = false,
  lsp_diagnostics     = true,
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
  },
  system_open = {
    cmd  = nil,
    args = {}
  },

  view = {
    width = 25,
    height = 30,
    side = 'left',
    auto_resize = true,
    mappings = {
      custom_only = false,
    }
  }
}

-- Mappings
local map = vim.api.nvim_set_keymap
map('n', '<C-p>', ':NvimTreeToggle <CR>', { noremap = true })
