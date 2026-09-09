-- Native LSP Setup (Neovim 0.11+ Standard)
-- Generate autocomplete capabilities globally
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
-- Map nvim-cmp's required capabilities
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- TypeScript / JS
vim.lsp.config('ts_ls', {
    capabilities = capabilities
})
vim.lsp.enable('ts_ls')

-- Lua
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = { diagnostics = { globals = { 'vim' } } }
    }
})
vim.lsp.enable('lua_ls')

-- Clangd (C/C++)
vim.lsp.config('clangd', {
    capabilities = capabilities,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})
vim.lsp.enable('clangd')
