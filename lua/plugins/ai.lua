-- Use your favorite package manager to install, for example in lazy.nvim
--  Optionally, you can also install nvim-telescope/telescope.nvim to use some search functionality.
return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       panel = {
  --         enabled = true,
  --         auto_refresh = false,
  --         keymap = {
  --           jump_prev = "[[",
  --           jump_next = "]]",
  --           accept = "<CR>",
  --           refresh = "gr",
  --           open = "<M-CR>",
  --         },
  --         layout = {
  --           position = "bottom", -- | top | left | right
  --           ratio = 0.4,
  --         },
  --       },
  --       suggestion = {
  --         enabled = true,
  --         auto_trigger = true,
  --         debounce = 5,
  --         keymap = {
  --           accept = "<C-l>",
  --           accept_word = false,
  --           accept_line = false,
  --           next = "<C-]>",
  --           prev = "<M-[>",
  --           dismiss = "<C-]>",
  --         },
  --       },
  --       filetypes = {
  --         yaml = false,
  --         markdown = false,
  --         help = false,
  --         gitcommit = false,
  --         gitrebase = false,
  --         hgcommit = false,
  --         svn = false,
  --         cvs = false,
  --         ["."] = false,
  --       },
  --       copilot_node_command = "node", -- Node.js version must be > 18.x
  --       server_opts_overrides = {},
  --     })
  --   end,
  -- },
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup({})
  --   end,
  -- },
  -- {
  --   "sourcegraph/sg.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", --[[ "nvim-telescope/telescope.nvim ]]
  --   },
  --
  --   -- If you have a recent version of lazy.nvim, you don't need to add this!
  --   build = "nvim -l build/init.lua",
  --   config = true,
  -- },
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh",
    config = function()
      require("tabnine").setup({
        disable_auto_comment = true,
        accept_keymap = "<C-l>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 700,
        suggestion_color = { gui = "red", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt", "NvimTree" },
        log_file_path = nil, -- absolute path to Tabnine log file
      })
    end,
  },
}
