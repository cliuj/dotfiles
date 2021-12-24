local fn = vim.fn
local opt = vim.opt
local o = vim.o
local map = vim.api.nvim_set_keymap

-- Give more space for displaying messages
opt.cmdheight = 2

-- Don't pass messages to |ins-completion-menu|
o.shortmess = o.shortmess .. 'c'

if fn.has('nvim-0.5.0') == 1 or fn.has('patch-8.1.1564') == 1 then
  opt.signcolumn='number'
else
  opt.signcolumn='yes'
end

function show_documentation()
  local filetype = vim.bo.filetype
  if filetype == 'vim' or filetype == 'help' then
    vim.api.nvim_command('h ' .. filetype)

  elseif vim.call('coc#rpc#ready') then
    fn.CocActionAsync('doHover')
  end
end


-- Smart tabbing from:
-- https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
local function tc(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function _G.smart_tab_next()
  return fn.pumvisible() == 1 and tc'<C-n>' or tc'<Tab>'
end

function _G.smart_tab_prev()
  return fn.pumvisible() == 1 and tc'<C-p>' or tc'<S-Tab>'
end

map('n', 'K', ':lua show_documentation()<CR>', { noremap = false, silent = false })
map('i', '<Tab>', 'v:lua.smart_tab_next()', { expr = true, noremap = true })
map('i', '<S-Tab>', 'v:lua.smart_tab_prev()', { expr = true, noremap = true })

vim.cmd([[
  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif
]])
