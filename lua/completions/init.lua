local cmp = require("cmp")
local luasnip = require("luasnip")

-----------------------------------------------------------
-- Neovim completion behavior
-----------------------------------------------------------

vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
}

-----------------------------------------------------------
-- Appearance
-----------------------------------------------------------

vim.api.nvim_set_hl(0, "CmpBorder", {
    fg = "#f5c2e7",
    bg = "#1e1e2e",
})

vim.api.nvim_set_hl(0, "CmpPmenu", {
    bg = "#1e1e2e",
})

vim.api.nvim_set_hl(0, "CmpSel", {
    bg = "#313244",
    bold = true,
})

vim.api.nvim_set_hl(0, "CmpDoc", {
    bg = "#181825",
})

vim.api.nvim_set_hl(0, "CmpDocBorder", {
    fg = "#f5c2e7",
    bg = "#181825",
})

vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {
    fg = "#89b4fa",
    bold = true,
})

vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {
    fg = "#89b4fa",
    bold = true,
})

-----------------------------------------------------------
-- Completion kind icons
-----------------------------------------------------------

local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "",
}

local source_names = {
    nvim_lsp = "[LSP]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
    path = "[Path]",
}

-----------------------------------------------------------
-- Helper for smart <Tab>
-----------------------------------------------------------

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    if col == 0 then
        return false
    end

    return vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s") == nil
end

-----------------------------------------------------------
-- Main CMP setup
-----------------------------------------------------------

cmp.setup({
    -------------------------------------------------------
    -- Completion behavior
    -------------------------------------------------------

    completion = {
        completeopt = "menu,menuone,noselect",
        keyword_length = 1,
    },

    preselect = cmp.PreselectMode.None,

    -------------------------------------------------------
    -- Snippets
    -------------------------------------------------------

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    -------------------------------------------------------
    -- Performance
    -------------------------------------------------------

    performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,

        -- Avoid giant menus
        max_view_entries = 30,
    },

    -------------------------------------------------------
    -- Windows
    -------------------------------------------------------

    window = {
        completion = cmp.config.window.bordered({
            border = "rounded",

            winhighlight = table.concat({
                "Normal:CmpPmenu",
                "FloatBorder:CmpBorder",
                "CursorLine:CmpSel",
                "Search:None",
            }, ","),

            side_padding = 1,
            scrollbar = true,
            max_height = 12,
        }),

        documentation = cmp.config.window.bordered({
            border = "rounded",

            winhighlight = table.concat({
                "Normal:CmpDoc",
                "FloatBorder:CmpDocBorder",
                "Search:None",
            }, ","),

            max_width = 70,
            max_height = 18,
            scrollbar = true,
        }),
    },

    -------------------------------------------------------
    -- Documentation
    -------------------------------------------------------

    view = {
        docs = {
            auto_open = true,
        },
    },

    -------------------------------------------------------
    -- Formatting
    -------------------------------------------------------

    formatting = {
        fields = {
            "abbr",
            "kind",
            "menu",
        },

        format = function(entry, vim_item)
            local icon = kind_icons[vim_item.kind]

            if icon then
                vim_item.kind =
                    string.format("%s %s", icon, vim_item.kind)
            end

            vim_item.menu =
                source_names[entry.source.name]
                or ("[" .. entry.source.name .. "]")

            -- Don't let ridiculously long candidates destroy the UI
            local max_length = 50

            if
                vim_item.abbr
                and vim.fn.strdisplaywidth(vim_item.abbr) > max_length
            then
                vim_item.abbr =
                    vim.fn.strcharpart(
                        vim_item.abbr,
                        0,
                        max_length - 1
                    ) .. "…"
            end

            return vim_item
        end,
    },

    -------------------------------------------------------
    -- Keymaps
    -------------------------------------------------------

    mapping = cmp.mapping.preset.insert({
        ---------------------------------------------------
        -- Navigate completion
        ---------------------------------------------------

        ["<C-j>"] = cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select,
        }),

        ["<C-k>"] = cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select,
        }),

        ---------------------------------------------------
        -- Documentation
        ---------------------------------------------------

        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),

        ---------------------------------------------------
        -- Manual completion
        ---------------------------------------------------

        ["<C-Space>"] = cmp.mapping.complete(),

        ---------------------------------------------------
        -- Abort
        ---------------------------------------------------

        ["<C-e>"] = cmp.mapping.abort(),

        ---------------------------------------------------
        -- Confirm
        ---------------------------------------------------

        ["<CR>"] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Insert,
        }),

        ---------------------------------------------------
        -- Smart Tab
        ---------------------------------------------------

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()

            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()

            elseif has_words_before() then
                cmp.complete()

            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),

        ---------------------------------------------------
        -- Smart Shift-Tab
        ---------------------------------------------------

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()

            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)

            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    }),

    -------------------------------------------------------
    -- Sources
    -------------------------------------------------------

    sources = cmp.config.sources(
        {
            {
                name = "nvim_lsp",
                priority = 1000,
            },

            {
                name = "luasnip",
                priority = 750,
            },

            {
                name = "path",
                priority = 500,
            },
        },

        -- fallback group
        {
            {
                name = "buffer",
                priority = 250,
                keyword_length = 3,
            },
        }
    ),

    -------------------------------------------------------
    -- Sorting
    -------------------------------------------------------

    sorting = {
        priority_weight = 2,

        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },

    -------------------------------------------------------
    -- Ghost text
    -------------------------------------------------------

    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
})

-----------------------------------------------------------
-- Search completion: / and ?
-----------------------------------------------------------

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),

    sources = {
        {
            name = "buffer",
        },
    },
})

-----------------------------------------------------------
-- Command-line completion: :
-----------------------------------------------------------

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),

    sources = cmp.config.sources(
        {
            {
                name = "path",
            },
        },
        {
            {
                name = "cmdline",
            },
        }
    ),

    matching = {
        disallow_symbol_nonprefix_matching = false,
    },
})
