-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Notification after file change
-- https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
  pattern = "*",
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

vim.api.nvim_create_user_command("Run8816", function ()
  vim.cmd("call VimuxCloseRunner()")
  vim.cmd("call VimuxRunCommand('sh /opt/wwwroot/air/scripts/run_attach_8816.sh')")
end, {desc="Run tracker application"})

vim.api.nvim_create_user_command("Run8816air", function ()
  vim.cmd("call VimuxCloseRunner()")
  vim.cmd("call VimuxRunCommand('cd /opt/wwwroot/air/ && make air_8816')")
end, {desc="Run tracker application"})
