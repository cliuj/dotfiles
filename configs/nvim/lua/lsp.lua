local lspconfig = require('lspconfig')
local servers = { 'gopls', 'rnix', 'hls'}
for _, server in ipairs(servers) do
    lspconfig[server].setup {}
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- delay update diagnostics
    update_in_insert = false,
  }
)
