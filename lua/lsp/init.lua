-----------------------------------------------------------
-- nvim-cmp <-> LSP capabilities
-----------------------------------------------------------

local capabilities =
    require("cmp_nvim_lsp").default_capabilities()

-----------------------------------------------------------
-- Apply CMP capabilities to every LSP config
-----------------------------------------------------------

vim.lsp.config("*", {
    capabilities = capabilities,
})

-----------------------------------------------------------
-- Enable language servers
-----------------------------------------------------------

vim.lsp.enable({
    "ts_ls",
    "lua_ls",
})
