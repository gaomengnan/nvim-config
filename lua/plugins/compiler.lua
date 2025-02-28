return {
  {
    "ej-shafran/compile-mode.nvim",
    -- tag = "v5.*",
    -- you can just use the latest version:
    branch = "latest",
    -- or the most up-to-date updates:
    -- branch = "nightly",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- if you want to enable coloring of ANSI escape codes in
      -- compilation output, add:
      -- { "m00qek/baleia.nvim", tag = "v1.3.0" },
    },
    config = function()
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        -- to add ANSI escape code support, add:
        baleia_setup = true,
      }
    end,
  },
  -- { -- This plugin
  --   "Zeioth/compiler.nvim",
  --   cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  --   dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
  --   opts = {},
  -- },
  -- { -- The task runner we use
  --   "stevearc/overseer.nvim",
  --   commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
  --   cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  --   opts = {
  --     task_list = {
  --       direction = "bottom",
  --       min_height = 25,
  --       max_height = 25,
  --       default_detail = 1,
  --     },
  --   },
  -- },
}
