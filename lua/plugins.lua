return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
    },
    "neovim/nvim-lspconfig",
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- editing
    "windwp/nvim-autopairs",
    "tpope/vim-surround",
    "lukas-reineke/indent-blankline.nvim",
    -- lsp
    "mfussenegger/nvim-lint",
    "williamboman/mason.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "akinsho/bufferline.nvim",
    { "akinsho/toggleterm.nvim", version = "*", config = true },
    -- tmux
    "christoomey/vim-tmux-navigator",
    "mfussenegger/nvim-jdtls",
    'nvim-lua/plenary.nvim',
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    'L3MON4D3/LuaSnip',
    "saadparwaiz1/cmp_luasnip",
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        }
    },
    'stevearc/aerial.nvim',
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        -- configured in lua/claude.lua
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        opts = {},
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    "sphamba/smear-cursor.nvim",
    "tpope/vim-fugitive",
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        -- configured in lua/formatter/init.lua
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        -- configured in lua/config/snacks/init.lua
        opts = function()
            return require("config.snacks")
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        version = "^19.0.0",
        opts = {},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
