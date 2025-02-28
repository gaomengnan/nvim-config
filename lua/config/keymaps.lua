-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- discipline.cowboy()
local Util = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = vim.keymap.set
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "save windows" })
map("n", "<leader>;", "<cmd>Veil<cr>", { desc = "dashboard" })
map("n", "0", "^", { desc = "line header" })
-- lvim.keys.normal_mode['gr'] = '<cmd>lua vim.lsp.buf.references()<cr>'
map("n", "gR", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "References quicklist" })

-- GoTo code navigation
-- map("n", "gd", "<Plug>(coc-definition)", { silent = true })
-- map("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
-- map("n", "gI", "<Plug>(coc-implementation)", { silent = true })
-- map("n", "gr", "<Plug>(coc-references)", { silent = true })

map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Floating terminal" })
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("n", "<leader>tv", "<cmd>2ToggleTerm size=100 direction=vertical<cr>", { desc = "Split terminal vertical" })
map("n", "<leader>th", "<cmd>2ToggleTerm size=10 direction=horizontal<cr>", { desc = "Split terminal horizontal" })
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- map("n", "<C-w>j", "<CMD>m .+1<CR>", { desc = "Move down" })
-- map("n", "<C-w>k", "<CMD>m .-2<CR>", { desc = "Move up" })

-- move lines
map("n", "<C-w>j", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<C-w>k", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<C-w>j", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<C-w>k", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map("n", "md", "<cmd>Lspsaga peek_definition<CR>", { desc = "Lspsaga peek_definition" })
map("n", "ma", "<cmd>:Lspsaga code_action<cr>", { desc = "Lspsaga code_action" })
map("n", "mf", "<cmd>Lspsaga finder tyd+ref+imp+def<CR>", { desc = "Lspsaga finder" })
map("n", "mr", "<cmd>Lspsaga rename<CR>", { desc = "Lspsaga rename" })

map("n", ";n", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Lspsaga finder" })

-- Telescope lsp_document_symbols
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Docuemt symbols" })

-- toggle max screen
map("n", "<C-w>m", "<cmd>MaximizerToggle<CR>", { desc = "Toggle max screen" })

map("n", "ger", "<CMD>GoIfErr<CR>", { desc = "GoIfErr" })
map("n", "c'", "ci'", { desc = "" })
map("n", 'c"', 'ci"', { desc = "" })
map("n", "c)", "ci)", { desc = "" })
map("n", "c}", "ci}", { desc = "" })
map("n", "c]", "ci]", { desc = "" })
map("n", "c`", "ci`", { desc = "" })
map("n", "c>", "ci>", { desc = "" })
map("n", "<leader>ue", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undotree history" })
map("n", "<leader>yf", "<cmd>YankyRingHistory<cr>", { desc = "Toggle paste history" })
-- map("n", "<C-a>", "ggvG", { desc = "All Select" })
-- map("n", "<leader>fm", "<cmd>CocCommand flutter.emulators<cr>", {desc=" Open ios simulator"})
-- map("n", "<leader>fs", "<cmd>CocCommand flutter.run<cr>", {desc="Run flutter project"})
-- map("n", "<leader>fd", "<cmd>CocCommand flutter.dev.quit<cr>", {desc="Stop flutter project"})
-- map("n", "<leader>fv", "<cmd>CocCommand flutter.devices<cr>", {desc="Run devices"})
map("n", "<leader>fm", "<cmd>FlutterEmulators<cr>", { desc = " Open ios simulator" })
map("n", "<leader>fs", "<cmd>FlutterRun<cr>", { desc = "Run flutter project" })
map("n", "<leader>fd", "<cmd>FlutterQuit<cr>", { desc = "Stop flutter project" })
map("n", "<leader>fp", "<cmd>FlutterRestart<cr>", { desc = "Stop flutter project" })
-- yanky keymap configuration
-- vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
-- vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
-- vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
-- vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
-- vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
-- vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

if vim.g.vscode then
  -- nnoremap <C-w>gd <Cmd>lua require('vscode-neovim').action('editor.action.revealDefinitionAside')<CR>
  map(
    "n",
    "gd",
    "<Cmd>lua require('vscode-neovim').action('editor.action.revealDefinition')<CR>",
    { desc = "GotoDefinition" }
  )
  map(
    "n",
    "gD",
    "<Cmd>lua require('vscode-neovim').action('editor.action.peekDefinition')<CR>",
    { desc = "GotoDefinition" }
  )
  map(
    "n",
    "gy",
    "<Cmd>lua require('vscode-neovim').action('editor.action.revealDeclaration')<CR>",
    { desc = "GotoDefinition" }
  )
  map(
    "n",
    "gI",
    "<Cmd>lua require('vscode-neovim').action('editor.action.goToImplementation')<CR>",
    { desc = "GotoDefinition" }
  )
end

map("n", "gee", "<cmd>lua require('gaomengnan.discipline').insert_go_err()<cr>", { desc = "Go Error" })
map("n", "<leader>dT", "<cmd>lua require('gaomengnan.debug').debug()<cr>", { desc = "Debug" })
-- map("n", "<leader>cc", "<cmd>:Lspsaga code_action<cr>", { desc = "Lspsaga code_action" })
map("n", "<leader>gS", "<cmd>DiffviewOpen<cr>", { desc = "diffview open" })
map("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "neogit open" })

map("n", "<leader>be", "<cmd>lua require('memento').toggle()<cr>", { desc = "buffer explorer open" })

map(
  "n",
  "<leader>pp",
  "<cmd>lua require'telescope'.extensions.projects.projects{}<cr>",
  { desc = "Open project picker" }
)

map(
  "n",
  "<leader>wh",
  "<cmd>lua require('gaomengnan.discipline').attach_go_debugger({})<cr>",
  { desc = "Debug remote" }
)

vim.keymap.set("n", "<leader>rc", ":RunCode<CR>", { noremap = true, silent = false })
vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })

map("n", "<leader>dA", "<cmd>lua require('gaomengnan.discipline').attach_pid()<cr>", { desc = "Debug Tracker" })
-- vim.keymap.set('n', '<F5>', "<CMD>lua require 'dap'.continue<cr>", { noremap = true, silent = false })
-- vim.keymap.set('n', '<F11>', "<CMD>lua require 'dap'.step_into<cr>", { noremap = true, silent = false })
-- vim.keymap.set('n', '<F11>', "<CMD>lua require 'dap'.step_out<cr>", { noremap = true, silent = false })

--  删除keymap
-- vim.keymap.del("n", "<C-Down>")

-- vim.keymap.set("n", "<leader>kk", function()
--   local ts_utils = require("nvim-treesitter.ts_utils")
--   local node = ts_utils.get_node_at_cursor()
--   if node then
--     local node_type = node:type()
--     if node_type == "type_identifier" then
--       local method = vim.fn.input("Method:")
--       print(method)
--     end
--   end
-- end)

vim.keymap.del("n", ";")

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

map("n", "<leader>cn", "<cmd>Compile<cr>", { noremap = true, silent = true })
map("i", "jk", "<ESC>", { noremap = true, silent = true })
-- map("n", "<leader>pC", "<cmd>CompilerRedo<cr>", { noremap = true, silent = true })
