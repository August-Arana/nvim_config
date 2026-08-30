-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

-- [CHANGE 9] FloatBorder is the highlight group used by bordered() windows.
-- Many themes set it to match the background, making borders invisible.
-- We override it here with Catppuccin Pink (#f5c2e7) so it's always visible.
--vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#f5c2e7' })
vim.api.nvim_set_hl(0, 'CmpBorder', { fg = '#f5c2e7', bg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'CmpPmenu', { bg = '#1e1e2e' })
vim.api.nvim_set_hl(0, 'CmpSel', { bg = '#313244', bold = true })
vim.api.nvim_set_hl(0, 'CmpDoc', { bg = '#181825' })
vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = '#f5c2e7', bg = '#181825' })

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    -- [CHANGE 8] Performance: debounce/throttle reduce how aggressively cmp
    -- queries sources on every keystroke — helps on slow LSPs or large files.
    performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
    },

    window = {
      completion = cmp.config.window.bordered({
        winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None',
      }),
      documentation = cmp.config.window.bordered({
        winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpSel,Search:None',
      }),
    },

    -- [CHANGE 3] Ghost text: shows the top candidate as faded inline text
    -- after your cursor without opening the full popup — non-intrusive preview.
    experimental = {
        ghost_text = true,
    },

    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),

        -- [CHANGE 4] select = false: <CR> only confirms an item you've actively
        -- highlighted. Previously (select = true) it would silently insert the
        -- first suggestion even if you just pressed Enter for a new line.
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- [CHANGE 5] Snippet jump mappings: after a snippet expands, <Tab> and
        -- <S-Tab> jump forward/backward between its placeholders (e.g. function
        -- name → args → body). Without this you'd navigate manually.
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        -- [CHANGE 2] priority: LSP results (context-aware) rank above snippets
        -- and buffer words so they appear at the top of the list.
        { name = 'nvim_lsp', priority = 1000 },
        -- [CHANGE 1] luasnip added as a source: having luasnip as the snippet
        -- *engine* doesn't make snippets appear in the menu — this does.
        { name = 'luasnip',  priority = 750 },
        -- [CHANGE 6] path source in insert mode: gives file-path completions
        -- inline (e.g. inside require('./') or open(')) not just in cmdline.
        { name = 'path',     priority = 500 },
        -- [CHANGE 2b] keyword_length = 3 on buffer: avoids suggesting 1-2 char
        -- words from open buffers, which are usually noise.
        { name = 'buffer',   priority = 250, keyword_length = 3 },
    }),
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
