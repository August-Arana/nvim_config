return {
    "olimorris/onedarkpro.nvim",
    -- nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    -- airline
    "vim-airline/vim-airline",
    "vim-airline/vim-airline-themes",
    -- nerdtree
    "preservim/nerdtree",
    "ryanoasis/vim-devicons",
    -- color
    "navarasu/onedark.nvim",
    -- editing
    "windwp/nvim-autopairs",
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "lukas-reineke/indent-blankline.nvim",
    -- lsp
    "mfussenegger/nvim-lint",
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason-lspconfig.nvim",
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
    "nvimtools/none-ls.nvim",
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
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'BurntSushi/ripgrep',
        }
    },

}
