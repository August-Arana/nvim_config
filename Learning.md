# Neovim - Where to See Errors / Logs

## 1. Messages / Notifications
```
:messages
```
Shows all recent messages and errors from the current session.

## 2. LSP logs
```
:LspLog
```
Opens the LSP client log file (usually at `~/.local/state/nvim/lsp.log`).

## 3. Neovim log
```vim
:lua print(vim.fn.stdpath('log'))
```
Shows the log directory. The main log is `nvim/log` inside it. Open it with:
```vim
:lua vim.cmd('edit ' .. vim.fn.stdpath('log') .. '/nvim')
```

## 4. Startup errors
```
nvim --startuptime /tmp/startup.log
```
Run from terminal to capture startup timing and errors.

## 5. Lua errors (runtime)
```vim
:lua vim.notify(vim.inspect(something))
```
Or check `:messages` after an error occurs — Lua tracebacks appear there.

## 6. Lazy.nvim specific
```
:Lazy log
```
Shows plugin update/install logs. `:Lazy` shows any plugin errors in the UI.

## Most common workflow
Run `:messages` first, then `:LspLog` if it's LSP-related.

---

# nvim-cmp (Completions) — Concepts & Improvements

## 1. Sources need to be declared
`nvim-cmp` only suggests completions from sources you explicitly list. Having `luasnip` as your snippet *engine* doesn't mean snippets appear in the menu — you also need `{ name = 'luasnip' }` in the sources list. Same idea applies to `path`, `buffer`, etc.

## 2. Source priority & keyword_length
All sources compete equally by default. You can give `priority` numbers so LSP results (context-aware) rank above generic buffer words. `keyword_length` on a source sets the minimum characters typed before that source activates — e.g. `keyword_length = 3` on `buffer` prevents single/double-char noise.

## 3. Ghost text (`experimental.ghost_text`)
Shows the top completion candidate as faded inline text after your cursor — like Copilot suggestions — without opening the popup menu. Non-intrusive. The full menu still opens when you navigate with your keys.

## 4. `confirm({ select = true })` — the silent confirm trap
With `select = true`, pressing `<CR>` confirms the *first item in the list* even if you never touched the menu. This means hitting Enter to go to a new line can silently insert a completion. `select = false` makes `<CR>` only confirm something you've *actively highlighted* with the navigation keys.

## 5. Snippet jump mappings
When a snippet expands, it has *placeholders* (e.g. function name, argument list, body). To jump between them you need mappings wired to `luasnip.jump(1)` / `luasnip.jump(-1)`. The standard binding is `<Tab>` / `<S-Tab>`. Without this you'd have to navigate to each placeholder manually.

## 6. `path` source in insert mode
The `path` source gives file-path completions. By default people only add it to cmdline (`:e`, `:split`). Adding it to insert-mode sources means it also works inline — e.g. inside `require('./`, `open('`, or any string where a file path makes sense.

## 7. lspkind — icons/labels in the menu
`lspkind` adds icons or text labels (like `[LSP]`, `[Snippet]`, `[Buffer]`) next to each completion item so you can see at a glance where a suggestion comes from. Configured via `formatting.format` in the cmp setup.

## 8. Performance tuning
- `debounce` — waits N ms after you stop typing before querying sources. Avoids triggering completions on every single keystroke.
- `throttle` — limits how fast results are fed to the UI even when sources respond quickly.
- `fetching_timeout` — how long to wait for slow sources before showing partial results.
Matters most with remote/slow LSPs or very large files.

## 9. Border colors (`FloatBorder`)
`cmp.config.window.bordered()` draws borders using the `FloatBorder` highlight group. Many themes set this to match the float background, making borders invisible. Override it explicitly:
```lua
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#f5c2e7' }) -- Catppuccin Pink
```
Or scope it only to cmp windows using the `winhighlight` option inside `bordered()`.
