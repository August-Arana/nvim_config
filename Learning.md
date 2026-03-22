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
