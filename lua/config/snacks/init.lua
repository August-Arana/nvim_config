-------------------------------------------------------------------------------
-- Snacks
-- Plugin: folke/snacks.nvim
-- Docs:   https://github.com/folke/snacks.nvim
--
-- Returns the opts table consumed by the spec in lua/plugins.lua.
-- This lives under config/ on purpose: a lua/snacks/ folder would shadow the
-- plugin's own `snacks` module, because the config dir is first in runtimepath.
-------------------------------------------------------------------------------

---@type snacks.Config
return {
    -- Performance
    bigfile = { enabled = true },
    quickfile = { enabled = true },

    -- Startup screen
    dashboard = {
        enabled = true,
        preset = {
            header = table.concat({
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }, "\n"),
            keys = {
                { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
                { icon = "󰈔 ", key = "n", desc = "New File", action = ":ene | startinsert" },
                { icon = "󰱼 ", key = "g", desc = "Grep Text", action = ":lua Snacks.picker.grep()" },
                { icon = "󰄉 ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
                { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
                { icon = "󰦛 ", key = "s", desc = "Restore Session", section = "session" },
                { icon = "󰋚 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
            },
        },
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 2 },
            { icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            { section = "startup" },
        },
    },

    -- UI
    notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
        top_down = false, -- stack notifications from the bottom
    },
    input = { enabled = true },
    picker = { enabled = true },
    statuscolumn = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },

    styles = {
        notification = { border = "rounded", wo = { wrap = true } },
        input = { relative = "cursor", border = "rounded" },
    },
}
