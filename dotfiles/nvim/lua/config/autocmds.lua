-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LazyVim reloads externally changed files on FocusGained, but switching herdr
-- panes does not always produce that event, so a file an agent rewrote in
-- another pane can stay stale here. Check on idle as well.
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("checktime_on_idle", { clear = true }),
  callback = function()
    if vim.o.buftype == "" and vim.fn.mode() == "n" then
      vim.cmd("silent! checktime")
    end
  end,
})
