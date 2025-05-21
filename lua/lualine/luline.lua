require('lualine').setup {
    options = {
        theme = {
            normal = {
                a = { fg = '#262626', bg = '#5fafd7', gui = 'bold' },
                b = { fg = '#ffffff', bg = '#767676' },
                c = { fg = '#ffffff', bg = '#262626' },
            },
            insert = { a = { fg = '#262626', bg = '#5fafd7', gui = 'bold' } },
            visual = { a = { fg = '#262626', bg = '#5fafd7', gui = 'bold' } },
            replace = { a = { fg = '#262626', bg = '#5fafd7', gui = 'bold' } },
            inactive = {
                a = { fg = '#767676', bg = '#262626' },
                b = { fg = '#767676', bg = '#262626' },
                c = { fg = '#767676', bg = '#262626' },
            },
        },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
    },
    sections = {
        lualine_a = {
            { 'mode', icon = '' },
        },
        lualine_b = {
            { 'branch', icon = '' },
            'diff',
        },
        lualine_c = {
            {
                'filename',
                symbols = { modified = ' ●', readonly = ' ', unnamed = ' [No Name]' },
                path = 1,
            },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            },
        },
        lualine_x = {
            { 'filetype', icon_only = true },
            'encoding',
            'fileformat',
        },
        lualine_y = {
            {
                'progress',
                icon = '󰦨',
            },
        },
        lualine_z = {
            {
                'location',
                icon = '',
            },
        },
    },
}
