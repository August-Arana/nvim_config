-- opts for using in all file
local opts = { noremap = true, silent = true}

-- just a constante to do things easier
local km = vim.keymap.set
km("v", "p", '"_dP', opts)
vim.cmd(' autocmd TermOpen * startinsert ')
-- Set leader key
vim.g.mapleader = ' '

-- Normal mode Keymaps
-- Only C compiler:
--km(
--    "n",
--    "<space>cc",
--   ':execute("!gnome-terminal -- bash -c \'gcc " . shellescape("%") . " -o " . shellescape("%<") . " && ./" . shellescape("%<") . "\'")<CR>',
--   opts 
--)

-- for C++ and C

km("n", "<space>cc", function()
  local compiler = "gcc"

  if vim.bo.filetype == "cpp" then
    compiler = "g++"
  end

  local file = vim.fn.shellescape(vim.fn.expand("%:p"))
  local output = vim.fn.shellescape(vim.fn.expand("%:p:r"))

  vim.cmd("!" ..
    "gnome-terminal -- bash -c " ..
    vim.fn.shellescape(
      compiler .. " " .. file .. " -o " .. output .. " && " .. output .. "; exec bash"
    )
  )
end, opts)

-- Save, quit
km('n', '<space>w', '<cmd>:w<cr>')
km('n', '<space>q', '<cmd>:q<cr>')
km('n', '<space>x', '<cmd>:bd<cr>')
km('n', '<space>wq', '<cmd>:wq<cr>')

km('n', '<leader>t', ':Neotree toggle=true<cr>', opts)
km('n', '<leader>e', ':Lexplore 20<cr>', opts)
km("n", "<leader>p", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 5000 })<CR>", opts)
km('n', '<leader>a', ':lua ToggleFold()<CR>', opts)
km('n', '<leader>k', ':BufferLineCycleNext<CR>', opts)
km('n', '<leader>j', ':BufferLineCyclePrev<CR>', opts)
km('n', '<leader>M', ':Mason<CR>', opts)
km('n', '<leader>ff', ':Telescope find_files<CR>', opts)
km('n', '<leader>fg', ':Telescope live_grep<CR>', opts)

-- Markdown
km('n', '<leader>md', '<cmd>RenderMarkdown toggle<CR>', opts)

-- Change window size
km("n", "<C-w>", ":resize -2<CR>", opts)
km("n", "<C-s>", ":resize +2<CR>", opts)
km("n", "<C-d>", ":vertical resize +2<CR>", opts)
km("n", "<C-a>", ":vertical resize -2<CR>", opts)

-- move between windows
-- km("n", "<C-k>", "<C-w>k", opts)
-- km("n", "<C-j>", "<C-w>j", opts)
-- km("n", "<C-h>", "<C-w>h", opts)
-- km("n", "<C-l>", "<C-w>l", opts)

-- Visual Mode
-- Move things
km("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
km("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)


-- Insert mode Keymaps
km('i', 'jj', '<Esc>', opts)

-- Window navigation (normal mode) — replaces vim-tmux-navigator built-ins
-- since we disabled its auto-mappings (tmux_navigator_no_mappings = 1)
km("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", opts)
km("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", opts)
km("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", opts)
km("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", opts)

-- Terminal mode navigation — uses native Neovim window commands so that
-- <C-h/j/k/l> work correctly inside terminal buffers (Claude, ToggleTerm…)
-- without vim-tmux-navigator's broken tnoremap causing text injection.
km("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
km("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
km("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
km("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
