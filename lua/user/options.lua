vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.shiftwidth = 4
vim.opt.tabstop    = 4
vim.opt.expandtab  = true
-- Set autoindent and number
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true

vim.opt.mousemoveevent = true

vim.opt.clipboard = "unnamedplus"


--require("smear_cursor").setup({
--  stiffness = 0.5,
--  trailing_stiffness = 0.49,
--  never_draw_over_target = false
--})
require("smear_cursor").setup()
