require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        sql = { "sqlfluff" },
        php = { "pretty-php" },
        json = { "fixjson" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
    },
})


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.php" },
    callback = function()
        require("conform").format({ async = false, lsp_fallback = true })
    end,
})
