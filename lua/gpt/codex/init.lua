require("codex").setup({
    backend = "app_server",

    cmd = {
        "codex",
    },

    env = {},

    cwd = "root",

    root_markers = {
        ".git",
    },

    focus_after_send = true,

    terminal = {
        layout = "split",

        split_side = "right",

        split_width_percentage = 0.40,

        float = {
            width_percentage = 0.90,
            height_percentage = 0.90,
            border = "rounded",
        },

        auto_insert = true,
        auto_close = true,

        hide_keys = {
            "<C-/>",
            "<C-_>",
        },

        normal_mode_keys = {
            "<M-n>",
        },

        window_navigation = {
            left = "<M-h>",
            down = "<M-j>",
            up = "<M-k>",
            right = "<M-l>",
        },
    },

    context = {
        max_lines = 1000,
        max_bytes = 128 * 1024,
    },

    selection = {
        enabled = true,
        hint = true,

        keymaps = {
            ask = "<leader>oa",
            edit = "<leader>oe",
        },
    },

    app_server = {
        cmd = {
            "codex",
            "app-server",
        },
    },
})

local map = vim.keymap.set

------------------------------------------------------------------------
-- Session
------------------------------------------------------------------------

map("n", "<leader>oo", "<cmd>CodexFocus<cr>", {
    desc = "Codex: Focus / Hide",
})

map("n", "<leader>oO", "<cmd>CodexOpen<cr>", {
    desc = "Codex: Open",
})

map("n", "<leader>oh", "<cmd>CodexClose<cr>", {
    desc = "Codex: Hide",
})

map("n", "<leader>ox", "<cmd>CodexStop<cr>", {
    desc = "Codex: Stop",
})

------------------------------------------------------------------------
-- Conversation
------------------------------------------------------------------------

map("n", "<leader>op", "<cmd>CodexPrompt<cr>", {
    desc = "Codex: Prompt",
})

map("n", "<leader>oa", "<cmd>CodexAsk<cr>", {
    desc = "Codex: Ask",
})

map("n", "<leader>ou", "<cmd>CodexFollowUp<cr>", {
    desc = "Codex: Follow-up",
})

------------------------------------------------------------------------
-- Context
------------------------------------------------------------------------

map("n", "<leader>of", "<cmd>CodexAdd<cr>", {
    desc = "Codex: Add current file",
})

map("v", "<leader>oA", ":<C-U>CodexAddVisual<CR>", {
    desc = "Codex: Add selection",
})

map("v", "<leader>os", ":<C-U>CodexSendVisual<CR>", {
    desc = "Codex: Send selection",
})

map("n", "<leader>ot", "<cmd>CodexTreeAdd<cr>", {
    desc = "Codex: Add explorer selection",
})

------------------------------------------------------------------------
-- Sessions
------------------------------------------------------------------------

map("n", "<leader>or", "<cmd>CodexResume<cr>", {
    desc = "Codex: Resume",
})

map("n", "<leader>oc", "<cmd>CodexContinue<cr>", {
    desc = "Codex: Continue latest",
})

map("n", "<leader>ok", "<cmd>CodexFork<cr>", {
    desc = "Codex: Fork",
})

------------------------------------------------------------------------
-- Review / Diff
------------------------------------------------------------------------

map("n", "<leader>ov", "<cmd>CodexReview --uncommitted<cr>", {
    desc = "Codex: Review uncommitted",
})

map("n", "<leader>od", "<cmd>CodexDiff<cr>", {
    desc = "Codex: Latest diff",
})

map("n", "<leader>oi", "<cmd>CodexInterrupt<cr>", {
    desc = "Codex: Interrupt",
})

------------------------------------------------------------------------
-- Utilities
------------------------------------------------------------------------

map("n", "<leader>oz", "<cmd>CodexStatus<cr>", {
    desc = "Codex: Status",
})

map("n", "<leader>oH", "<cmd>CodexHealth<cr>", {
    desc = "Codex: Health",
})

map("n", "<leader>om", ":CodexImage ", {
    desc = "Codex: Image",
})


local group = vim.api.nvim_create_augroup(
    "CodexIntegration",
    { clear = true }
)

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "CodexTurnCompleted",
    callback = function()
        vim.notify(
            "Codex finished",
            vim.log.levels.INFO,
            { title = "Codex" }
        )
        vim.cmd("checktime")
    end,
})

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "CodexDiffUpdated",
    callback = function()
        vim.notify(
            "Codex diff updated",
            vim.log.levels.INFO,
            { title = "Codex" }
        )
        vim.schedule(function()
            vim.cmd("CodexDiff")
        end)
    end,
})
