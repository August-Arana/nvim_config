vim.cmd("colorscheme onedark")
require("config.lazy");
require "user.keyMaps"
require "user.options"
require("onedarkpro.helpers")

-- Plugins
local buffLine = require("bufferline")
local mason = require("mason")
local null_ls = require("null-ls")
local npairs = require('npairs')
local lspconfig = require("lspconfig")

mason.setup()
require("mason-lspconfig").setup({
    ensure_installed = { 'ts_ls' }
})
lspconfig.ts_ls.setup({})
lspconfig.lua_ls.setup({})
local elixir_ls_path = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/language_server.sh"

lspconfig.elixirls.setup({
    cmd = { elixir_ls_path },
    settings = {
        elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false
        }
    }
})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
    },
})

vim.cmd('autocmd FileType javascript setlocal shiftwidth=2')

vim.cmd('filetype plugin indent on')
vim.cmd("autocmd FileType perl setlocal equalprg=perltidy\\ -st")

local npairs = require('nvim-autopairs')

require("toggleterm").setup {
    size = 20,
    open_mapping = [[<c-t>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
}

require("ibl").setup()

require("completions")



function ToggleFold()
    if vim.fn.foldclosed('.') == -1 then
        vim.cmd('normal! $V%zf')
    else
        vim.cmd('normal! zo')
    end
end

require("neo-tree").setup({
    window = {
        width = 30,
    },
})


buffLine.setup {
    options = {
        buffer_close_icon = '󰅖',
        modified_icon = '▲ ',
        separator_style = 'slant',
        show_close_icon = false,
        mode = 'tabs',
        color_icons = true,
        diagnostics = "nvim_lsp",
        middle_mouse_command = "bdelete! %d",
    },
}
