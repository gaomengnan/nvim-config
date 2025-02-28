return {
  { "phpactor/phpactor" },
  -- {
  --   "phpactor/phpactor",
  -- },
  --
  { "stephpy/vim-php-cs-fixer" },
  {
    ft = { "php" },
    "ccaglak/namespace.nvim",
    keys = {
      { "<leader>lc", '<cmd>lua require("namespace.getClass").get()<cr>', { desc = "GetClass" } },
      { "<leader>la", '<cmd>lua require("namespace.getClasses").get()<cr>', { desc = "GetClasses" } },
      { "<leader>lr", '<cmd>lua require("namespace.classAs").open()<cr>', { desc = "ClassAs" } },
      { "<leader>ln", '<cmd>lua require("namespace.namespace").gen()<cr>', { desc = "Generate Namespace" } },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  -- {
  --   "Bleksak/laravel-ide-helper.nvim",
  --   opts = {
  --     write_to_models = true,
  --     save_before_write = true,
  --     format_after_gen = true,
  --   },
  --   enabled = function()
  --     return vim.fn.filereadable("artisan") ~= 0
  --   end,
  --   keys = {
  --     {
  --       "<leader>lgm",
  --       function()
  --         require("laravel-ide-helper").generate_models(vim.fn.expand("%"))
  --       end,
  --       desc = "Generate Model Info for current model",
  --     },
  --     {
  --       "<leader>lgM",
  --       function()
  --         require("laravel-ide-helper").generate_models()
  --       end,
  --       desc = "Generate Model Info for all models",
  --     },
  --   },
  -- },
}
