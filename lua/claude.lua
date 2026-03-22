-------------------------------------------------------------------------------
-- Claude Code Integration
-- Plugin: coder/claudecode.nvim
-- Docs:   https://github.com/coder/claudecode.nvim
-------------------------------------------------------------------------------

local ok, claudecode = pcall(require, "claudecode")
if not ok then
    vim.notify("claudecode.nvim not found", vim.log.levels.WARN)
    return
end

claudecode.setup({
    -- Terminal settings
    terminal_cmd = "claude",        -- CLI command to invoke
    split_side   = "right",         -- "left" | "right"
    split_width  = 40,              -- percentage of total width
    auto_close   = true,            -- close panel when Claude exits

    -- Diff integration
    diff_opts = {
        auto_close_on_accept = true,
        vertical_split        = true,
    },
})

-------------------------------------------------------------------------------
-- Keymaps  (<leader>cl prefix to avoid collisions with codex <leader>cx)
-------------------------------------------------------------------------------
local km   = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Toggle the Claude Code side panel
km("n", "<leader>cl", "<cmd>ClaudeCode<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: toggle panel" }))

-- Focus / bring the Claude panel into view
km("n", "<leader>cf", "<cmd>ClaudeCodeFocus<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: focus panel" }))

-- Add the current file to the Claude context
km("n", "<leader>ca", "<cmd>ClaudeCodeAdd<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: add file to context" }))

-- Send visual selection to Claude
km("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: send selection" }))

-- Diff review – accept or deny Claude's proposed changes
km("n", "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: accept diff" }))
km("n", "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>",
    vim.tbl_extend("force", opts, { desc = "Claude: deny diff" }))

-------------------------------------------------------------------------------
-- User commands (convenience wrappers with tab-completion)
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("ClaudeToggle",
    function() vim.cmd("ClaudeCode") end,
    { desc = "Toggle Claude Code panel" })

vim.api.nvim_create_user_command("ClaudeSend",
    function(args)
        if args.range > 0 then
            vim.cmd("'<,'>ClaudeCodeSend")
        else
            vim.notify("ClaudeSend: make a visual selection first", vim.log.levels.INFO)
        end
    end,
    { range = true, desc = "Send selection to Claude" })
