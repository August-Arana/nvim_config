vim.opt.showmode = false
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.shiftwidth = 4
vim.opt.tabstop    = 4
vim.opt.expandtab  = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.mousemoveevent = true
vim.opt.clipboard = "unnamedplus"
vim.o.cmdheight = 1

require("smear_cursor").setup()
