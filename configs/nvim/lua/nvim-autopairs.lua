require('nvim-autopairs').setup{}

-- Requires cmp.setup()
local cmp = require('cmp')
if cmp ~= nil then
  require("nvim-autopairs.completion.cmp").setup({
    --  map <CR> on insert mode
    map_cr = true,
  
    -- it will auto insert `(` (map_char) after select function or method item
    map_complete = true,
  
    -- automatically select the first item
    auto_select = true,
  
    -- use insert confirm behavior instead of replace
    insert = false,
  
    -- modifies the function or method delimiter by filetypes
    map_char = {
      all = '(',
      tex = '{'
    }
  })
end
