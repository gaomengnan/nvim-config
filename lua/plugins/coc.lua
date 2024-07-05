return {
  enabled = false,
  "neoclide/coc.nvim",
  -- build = "npm ci",
  branch = "release",
  config = function()
    vim.g.coc_node_path = os.getenv("COC_NODE")
    vim.g.coc_npm_cmd = os.getenv("COC_NPM")
    vim.g.coc_global_extensions = { "coc-vetur", "coc-json", "coc-tsserver"}
    local keyset = vim.keymap.set
    local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
    -- keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
    -- keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
    -- keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
    -- keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
    -- keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
    -- keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
    -- keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
    -- keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)
    -- Autocomplete
    function _G.check_back_space()
      local col = vim.fn.col(".") - 1
      return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
    end
    -- keyset(
    --   "i",
    --   "<c-n>",
    --   'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<c-n>" : coc#refresh()',
    --   opts
    -- )
    keyset("i", "<c-n>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<c-n>" : coc#refresh()', opts)

    keyset("i", "<c-p>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
    --
    --Make <CR> to accept selected completion item or notify coc.nvim to format
    --<C-g>u breaks current undo, please make your own choice
    keyset("i", "<c-m>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
    --
    --Use <c-j> to trigger snippets
    keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
    --Use <c-space> to trigger completion
    keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })
    -- keyset("i", "<CR>", "coc#pum#confirm()", { silent = true, expr = true })
    --
    --Use `[g` and `]g` to navigate diagnostics
    --Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
    keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

    -- GoTo code navigation
    keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
    keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
    keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
    keyset("n", "gr", "<Plug>(coc-references)", { silent = true })
    function _G.show_docs()
      local cw = vim.fn.expand("<cword>")
      if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
        vim.api.nvim_command("h " .. cw)
      elseif vim.api.nvim_eval("coc#rpc#ready()") then
        vim.fn.CocActionAsync("doHover")
      else
        vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
      end
    end
    keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    vim.api.nvim_create_augroup("CocGroup", {})
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "Highlight symbol under cursor on CursorHold",
    })

    keyset("x", "<leader>cc", "<Plug>(coc-codeaction-selected)", { silent = true })
    keyset("n", "<leader>cc", "<Plug>(coc-codeaction-selected)", { silent = true })

    -- Remap keys for apply code actions at the cursor position.
    keyset("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", { silent = true })
    -- Remap keys for apply source code actions for current file.
    keyset("n", "<leader>cs", "<Plug>(coc-codeaction-source)", { silent = true })
    -- Symbol renaming
    keyset("n", "<leader>cr", "<Plug>(coc-rename)", { silent = true })
    -- Formatting selected code
    -- keyset("x", "<leader>cf", "<Plug>(coc-format-selected)", {silent = true})
    keyset("n", "<leader>cf", "<cmd>call CocAction('format')<CR>", { silent = true, desc = "COC Format" })
    -- Add `:Format` command to format current buffer
    vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
    -- keyset("x", "<leader>ca", "<Plug>(coc-codeaction-selected)", {silent = true})
    -- keyset("n", "<leader>ca", "<Plug>(coc-codeaction-selected)", {silent = true})
    keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true })
    -- Run the Code Lens actions on the current line
    -- keyset("n", "<leader>cc", "<Plug>(coc-codelens-action)", {silent = true})
  end,
}
