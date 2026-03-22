# Neovim Configuration — Reference

Leader key: `Space`

---

## Keymaps

### File & Session

| Key | Action |
|-----|--------|
| `<leader>w` | Save file (`:w`) |
| `<leader>q` | Quit (`:q`) |
| `<leader>wq` | Save and quit (`:wq`) |
| `<leader>x` | Close buffer (`:bd`) |

### Navigation

| Key | Action |
|-----|--------|
| `<leader>k` | Next tab (BufferLine) |
| `<leader>j` | Previous tab (BufferLine) |
| `<leader>t` | Toggle Neo-tree file explorer |
| `<leader>e` | Open built-in Lexplore (20 cols) |

### Windows / Splits

| Key | Action |
|-----|--------|
| `<C-w>` | Decrease window height |
| `<C-s>` | Increase window height |
| `<C-d>` | Increase window width |
| `<C-a>` | Decrease window width |

> Window navigation between splits uses **vim-tmux-navigator** in normal mode (`<C-h/j/k/l>`). Its built-in terminal mappings are **disabled** (`tmux_navigator_no_mappings = 1`) because they injected literal text into terminal buffers (e.g. the Claude panel). Terminal mode uses native `<C-\><C-n><C-w>` navigation instead.

### Terminal

| Key | Action |
|-----|--------|
| `<C-t>` | Toggle floating terminal (ToggleTerm) |

Terminal opens in insert mode automatically.

### LSP

| Key | Action |
|-----|--------|
| `<leader>p` | Format current file (LSP) |
| `<leader>M` | Open Mason (LSP installer UI) |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search file contents) |

### Code Execution (C / C++)

| Key | Action |
|-----|--------|
| `<Space>cc` | Compile and run current file in a new terminal (`gcc` for C, `g++` for C++) |

### Editing Helpers

| Key | Mode | Action |
|-----|------|--------|
| `<leader>a` | Normal | Toggle fold on current block |
| `<A-j>` | Visual | Move selected lines down |
| `<A-k>` | Visual | Move selected lines up |
| `p` | Visual | Paste without yanking the replaced text |
| `jj` | Insert | Escape to normal mode |

### Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-j>` | Next completion item |
| `<C-k>` | Previous completion item |
| `<CR>` | Confirm selection |
| `<C-Space>` | Trigger completion manually |
| `<C-e>` | Abort completion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

### Claude Code (AI Assistant)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cl` | Normal | Toggle Claude Code panel |
| `<leader>cf` | Normal | Focus Claude Code panel |
| `<leader>ca` | Normal | Add current file to Claude context |
| `<leader>cs` | Visual | Send selection to Claude |
| `<leader>cy` | Normal | Accept Claude's diff proposal |
| `<leader>cn` | Normal | Deny Claude's diff proposal |

### Codex (OpenAI Codex)

| Key | Action |
|-----|--------|
| `<leader>cx` | Toggle Codex panel |

### Markdown

| Key | Action |
|-----|--------|
| `<leader>md` | Toggle in-buffer markdown rendering (render-markdown.nvim) |

---

## Plugins — Why They Are Installed

### Appearance
- **gruvbox** — main colorscheme
- **lualine.nvim** — status line with file info, git branch, diagnostics
- **bufferline.nvim** — tab/buffer bar at the top; shows LSP diagnostics per tab
- **indent-blankline.nvim (ibl)** — vertical indent guide lines
- **nvim-web-devicons** — file icons used by lualine, neo-tree, bufferline
- **onedarkpro.nvim / onedark.nvim** — alternative colorschemes (available but not active)

### File Navigation
- **neo-tree.nvim** — sidebar file explorer (replaces NERDTree for Lua-native experience)
- **telescope.nvim** — fuzzy finder for files, grep, buffers, and more
- **aerial.nvim** — code outline / symbol tree; shows functions and classes in a side panel

### LSP & Completion
- **mason.nvim** — installs and manages LSP servers, linters, formatters (`:MasonInstall <name>`)
- **mason-lspconfig.nvim** — bridges Mason with nvim-lspconfig; auto-installs `ts_ls`, `lua_ls`, `clangd`, `perlnavigator`
- **nvim-lspconfig** — configures the language server protocol client
- **none-ls.nvim (null-ls fork)** — pipes external tools (prettier) into the LSP format pipeline
- **nvim-cmp** — autocompletion engine
- **cmp-nvim-lsp / cmp-buffer / cmp-path / cmp-cmdline** — completion sources (LSP, open buffers, file paths, command line)
- **LuaSnip** — snippet engine used by nvim-cmp
- **nvim-lint** — async linting (separate from LSP diagnostics)

### Language-Specific
- **nvim-jdtls** — Java LSP client (Eclipse JDT); installed for Java project support
- **nvim-treesitter** — syntax highlighting and code understanding via AST parsing

### Editing
- **nvim-autopairs** — auto-closes brackets, quotes, etc.
- **vim-surround** — add/change/delete surrounding characters (`cs"'`, `ds"`, `ysiw"`)
- **vim-commentary** — toggle comments with `gc` (line) or `gcc` (block)

### Markdown
- **render-markdown.nvim** — renders markdown in-buffer (headings, code blocks, tables) without a browser; toggle with `<leader>md`

### Terminal & Workflow
- **toggleterm.nvim** — floating/split terminal inside Neovim; opens with `<C-t>`
- **vim-tmux-navigator** — unified `<C-h/j/k/l>` navigation across Vim splits and Tmux panes
- **todo-comments.nvim** — highlights `TODO:`, `FIXME:`, `NOTE:` etc. in code with colors

### AI
- **claudecode.nvim** — integrates Claude Code CLI into Neovim (side panel, diffs, context sharing)
- **codex.nvim** — integrates OpenAI Codex into Neovim

---

## LSP Servers

| Server | Language | Notes |
|--------|----------|-------|
| `ts_ls` | TypeScript / JavaScript | |
| `lua_ls` | Lua | `vim` global suppressed |
| `clangd` | C / C++ | needs `compile_commands.json` or `.git` at root |
| `perlnavigator` | Perl | formats on save via `perlnavigator` |

Prettier (via none-ls) formats JS/TS files when a `.prettierrc` or `prettier.config.js` is present, or when `prettier` is in `$PATH`.

---

## Auto-Behaviors

- **Perl files** (`.pl`, `.pm`): formatted on save via `vim.lsp.buf.format`
- **JavaScript files**: `shiftwidth` set to 2 (overrides the global 4)
- **Terminal buffers**: start in insert mode automatically

---

## Clipboard Sharing (Neovim ↔ Tmux)

Both neovim and tmux are configured to share the X11 system clipboard (`CLIPBOARD` selection) via `xclip`.

**How it's wired:**
- `vim.opt.clipboard = "unnamedplus"` — all neovim yanks/pastes use the system clipboard automatically.
- `~/.tmux.conf` — tmux copy mode `y` sends to system clipboard: `copy-pipe-and-cancel "xclip -selection clipboard -i"`.
- `tmux-yank` plugin — mouse selections in tmux copy mode also go to the system clipboard.

### Copy from tmux → paste in neovim

1. Enter tmux copy mode: `Ctrl-a [` (or `Ctrl-a y` to also scroll up)
2. Move with vi keys (`h/j/k/l`), press `v` to start selection, then `y` to copy.
3. Back in neovim, press `p` / `P` to paste.

### Copy from neovim → paste in tmux terminal

1. Yank in neovim with `y` (or any yank motion) — goes straight to system clipboard.
2. In the tmux terminal, paste with `Ctrl+Shift+V` or middle-click.

### Mouse drag in a tmux pane

Mouse drag goes to the X **PRIMARY** selection (not CLIPBOARD). Options:
- **Middle-click** to paste PRIMARY anywhere.
- Or enter copy mode (`Ctrl-a [`), re-select, and press `y` to promote it to CLIPBOARD.

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                  # Entry point: loads plugins, LSP, autocmds
├── lazy-lock.json            # Locked plugin versions (managed by lazy.nvim)
├── Instructions.md           # This file
└── lua/
    ├── plugins.lua           # Plugin list for lazy.nvim
    ├── claude.lua            # Claude Code plugin setup and keymaps
    ├── config/
    │   └── lazy.lua          # lazy.nvim bootstrap
    ├── completions/
    │   └── init.lua          # nvim-cmp configuration
    ├── user/
    │   ├── keyMaps.lua       # All custom keymaps
    │   └── options.lua       # Editor options (tabs, numbers, etc.)
    └── lualine/ / npairs/    # Per-plugin config modules
```

