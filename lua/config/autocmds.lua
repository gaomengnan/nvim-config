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

vim.api.nvim_create_augroup("CursorMovedGroup", {})
vim.api.nvim_create_autocmd("CursorMoved", {
  group = "CursorMovedGroup",
  pattern = "*",
  callback = function()
    -- require("gaomengnan.discipline").toggle_blame()
  end,
})

-- vim.api.nvim_create_user_command("R", function (opts)
--   print(vim.inspect(opts))
--   print("Args1: " .. opts.fargs[1])
--   print("Args: " .. table.concat(opts.fargs, ' '))
-- end, {desc = "run application"})

-- vim.api.nvim_create_user_command("Run8816", function ()
--   vim.cmd("call VimuxCloseRunner()")
--   vim.cmd("call VimuxRunCommand('sh /opt/wwwroot/air/scripts/run_attach_8816.sh')")
-- end, {desc="Run tracker application"})
--
-- vim.api.nvim_create_user_command("Run8816air", function ()
--   vim.cmd("call VimuxCloseRunner()")
--   vim.cmd("call VimuxRunCommand('cd /opt/wwwroot/air/ && make air_8816')")
-- end, {desc="Run tracker application"})

--自定义命令来实现一些功能
vim.api.nvim_create_user_command("Cf", function()
  require("gaomengnan.discipline").functions()
end, { desc = "Custom Functions" })

vim.api.nvim_create_user_command("GetSwagComment", function()
  require("gaomengnan.discipline").get_swag_comments()
end, { desc = "Get Swagger Comment" })

if vim.g.vscode == nil then
  require("gaomengnan.discipline").websocket()
  require("gaomengnan.discipline").timer_media()
end
