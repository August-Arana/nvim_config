local codecompanion = require("codecompanion")

codecompanion.setup({
  ---------------------------------------------------------------------------
  -- CODEX ACP
  ---------------------------------------------------------------------------

  adapters = {
    acp = {
      codex = function()
        return require("codecompanion.adapters").extend("codex", {
          defaults = {
            auth_method = "chat-gpt",
          },
        })
      end,
    },
  },

  ---------------------------------------------------------------------------
  -- INTERACTIONS
  ---------------------------------------------------------------------------

  interactions = {
    opts = {
      watcher = {
        enabled = true,
        debounce = 300,
      },
    },

    chat = {
      adapter = "codex",
    },
  },

  ---------------------------------------------------------------------------
  -- UI
  ---------------------------------------------------------------------------

  display = {
    chat = {
      window = {
        layout = "vertical",
        position = "right",
        full_height = true,
        width = 0.35,

        opts = {
          wrap = true,
          linebreak = true,
          breakindent = true,
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },

      show_settings = false,
      show_token_count = true,
      show_reasoning = true,
      fold_reasoning = true,
      show_context = true,
      fold_context = true,
    },

    diff = {
      enabled = true,
    },
  },

  ---------------------------------------------------------------------------
  -- DEBUG TEMPORAL
  ---------------------------------------------------------------------------

  opts = {
    log_level = "DEBUG",
  },
})

-------------------------------------------------------------------------------
-- KEYMAPS
-------------------------------------------------------------------------------

local map = vim.keymap.set

-- Abrir Codex explícitamente
map(
  { "n", "v" },
  "<leader>aa",
  "<cmd>CodeCompanionChat adapter=codex<cr>",
  {
    desc = "AI: Open Codex",
    silent = true,
  }
)

-- Toggle del chat
map(
  { "n", "v" },
  "<leader>at",
  "<cmd>CodeCompanionChat Toggle<cr>",
  {
    desc = "AI: Toggle Codex",
    silent = true,
  }
)

-- Agregar selección al chat
map(
  "v",
  "<leader>as",
  "<cmd>CodeCompanionChat Add<cr>",
  {
    desc = "AI: Add selection",
    silent = true,
  }
)

-- Acciones
map(
  { "n", "v" },
  "<leader>aA",
  "<cmd>CodeCompanionActions<cr>",
  {
    desc = "AI: Actions",
    silent = true,
  }
)

-- Archivos modificados
map(
  "n",
  "<leader>ac",
  "<cmd>CodeCompanionChat Changes<cr>",
  {
    desc = "AI: Changes",
    silent = true,
  }
)
