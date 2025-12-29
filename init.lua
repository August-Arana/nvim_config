require("config.lazy");
require "user.keyMaps"
require "user.options"
vim.cmd("colorscheme gruvbox")
-- require("onedarkpro.helpers")
require "lualine.luline"

-- Plugins
local buffLine = require("bufferline")
local mason = require("mason")
local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
local aerial = require("aerial")

mason.setup()
require("mason-lspconfig");
lspconfig.ts_ls.setup({})
lspconfig.lua_ls.setup({})
lspconfig.clangd.setup({
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
})

aerial.setup({
    attach_mode = "window", -- track the cursor
    highlight_on_hover = true,
})

lspconfig.perlnavigator.setup({
    cmd = { "perlnavigator", "--stdio" },
    filetypes = { "perl" },
    root_dir = lspconfig.util.root_pattern(".git", "Makefile.PL", "Build.PL", "."),
    settings = {
        perlnavigator = {
            perlPath = "perl",
            enableWarnings = true,
            formatOnSave = true,
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




local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace = capabilities.workspace or {}
capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }

lspconfig.perlnavigator.setup {
    capabilities = capabilities,
    settings = {
        perlnavigator = {
            perlPath = "/root/perl5/perlbrew/perls/perl-5.16.3/bin/perl", -- RUTA EXACTA DE TU PERL
            enableWarnings = true,
            diagnosticsEnabled = true,
            perlParams = "-Ilib", -- Ajusta si tienes librerías locales
            includePaths = { "lib" },
        }
    }
}

-- Opcional: refrescar diagnósticos al guardar
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.pl,*.pm",
    callback = function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
        vim.lsp.buf.format({ async = true })
    end
})
