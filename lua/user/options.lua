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
-- Clipboard unificado: y/d/p usan el CLIPBOARD del sistema ("+), y además
-- cada yank se copia al PRIMARY ("*) para que el click medio pegue lo mismo.
vim.opt.clipboard = "unnamed,unnamedplus"
-- Seleccionar con el mouse en nvim actualiza el PRIMARY (como en cualquier terminal)
vim.keymap.set("x", "<LeftRelease>", '"*ygv', { desc = "Mouse selection -> PRIMARY" })
-- Click derecho: pegar el CLIPBOARD del sistema (igual que en tmux)
vim.keymap.set({ "n", "x" }, "<RightMouse>", '"+P', { desc = "Paste clipboard" })
vim.keymap.set("i", "<RightMouse>", "<C-r><C-o>+", { desc = "Paste clipboard" })
vim.o.cmdheight = 1

require("smear_cursor").setup()
