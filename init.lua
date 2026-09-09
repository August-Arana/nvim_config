require("config.lazy")
require("user.keyMaps")
require("user.options")
require("formatter")
require("claude")
require("lsp")

vim.cmd("colorscheme catppuccin-mocha")

-- Plugins
local buffLine = require("bufferline")
local mason = require("mason")
local aerial = require("aerial")
local codex = require("codex")

-------------------------------------------------------------------------------
-- 1. Mason Setup (Run :MasonInstall prettier to fix your error)
-------------------------------------------------------------------------------
mason.setup()

-------------------------------------------------------------------------------
-- 2. Other Plugin Configurations
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
-- 3. Auto Commands & Settings
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    pattern = "javascript",
    callback = function() vim.opt_local.shiftwidth = 2 end,
})

-- Fold Toggle Function
function ToggleFold()
    if vim.fn.foldclosed('.') == -1 then
        vim.cmd('normal! $V%zf')
    else
        vim.cmd('normal! zo')
    end
end



codex.setup({})
codex.status()
vim.keymap.set("n", "<leader>cx", "<cmd>CodexToggle<cr>", { desc = "Codex: Toggle panel", })


vim.keymap.set("n", "<leader>ss", function()
  local handle = io.popen("~/bin/paste_image.sh")
  local result = handle:read("*a")
  handle:close()

  vim.api.nvim_put({ result }, "l", true, true)
end)
