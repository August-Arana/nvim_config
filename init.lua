require("config.lazy")
require("user.keyMaps")
require("user.options")

vim.cmd("colorscheme gruvbox")

-- Plugins
local buffLine = require("bufferline")
local mason = require("mason")
local null_ls = require("null-ls")
-- Note: 'lspconfig' require is removed to prevent the 0.11 deprecation warning
local aerial = require("aerial")

-------------------------------------------------------------------------------
-- 1. Mason Setup (Run :MasonInstall prettier to fix your error)
-------------------------------------------------------------------------------
mason.setup()
-- Ensure we have the binaries for the servers we want to use
require("mason-lspconfig").setup({
    ensure_installed = { "ts_ls", "lua_ls", "clangd", "perlnavigator" },
    automatic_installation = true, 
})

-------------------------------------------------------------------------------
-- 2. Native LSP Setup (Neovim 0.11+ Standard)
-------------------------------------------------------------------------------
-- Helper for root detection using native vim.fs
local function get_root(markers)
    return function(fname)
        return vim.fs.dirname(vim.fs.find(markers, { path = fname, upward = true })[1])
    end
end

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
    root_dir = get_root({ "compile_commands.json", "compile_flags.txt", ".git" }),
})
vim.lsp.enable('clangd')

-- PerlNavigator
vim.lsp.config('perlnavigator', {
    capabilities = capabilities,
    cmd = { "perlnavigator", "--stdio" },
    filetypes = { "perl" },
    root_dir = get_root({ ".git", "Makefile.PL", "Build.PL", "." }),
    settings = {
        perlnavigator = {
            perlPath = "perl",
            enableWarnings = true,
            formatOnSave = true,
        }
    }
})
vim.lsp.enable('perlnavigator')

-------------------------------------------------------------------------------
-- 3. Null-ls / None-ls Setup
-------------------------------------------------------------------------------
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin",
            -- Prevent crashing if prettier isn't found
            condition = function(utils)
                return utils.root_has_file({ ".prettierrc", "prettier.config.js" }) 
                    or vim.fn.executable("prettier") == 1
            end,
        }),
    },
})

-------------------------------------------------------------------------------
-- 4. Other Plugin Configurations
-------------------------------------------------------------------------------
aerial.setup({
    attach_mode = "window",
    highlight_on_hover = true,
})

-- Corrected lualine require (assuming standard installation)
require("lualine").setup() 

require("toggleterm").setup({
    size = 20,
    open_mapping = [[<c-t>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 1,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
})

require("ibl").setup()
require("completions")

require("neo-tree").setup({
    window = { width = 30 },
})

buffLine.setup({
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
})

-------------------------------------------------------------------------------
-- 5. Auto Commands & Settings
-------------------------------------------------------------------------------
vim.cmd('autocmd FileType javascript setlocal shiftwidth=2')
vim.cmd('filetype plugin indent on')
vim.cmd("autocmd FileType perl setlocal equalprg=perltidy\\ -st")

-- Perl formatting on save (Native LSP method)
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.pl,*.pm",
    callback = function()
        vim.lsp.buf.format({ async = true })
    end
})

-- Fold Toggle Function
function ToggleFold()
    if vim.fn.foldclosed('.') == -1 then
        vim.cmd('normal! $V%zf')
    else
        vim.cmd('normal! zo')
    end
end
