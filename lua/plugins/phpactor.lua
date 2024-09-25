return {
  -- { "phpactor/phpactor" },
  {
    "phpactor/phpactor", },

  { "stephpy/vim-php-cs-fixer" },
  { 
    ft = { 'php' },
    'ccaglak/namespace.nvim',
    keys = {
      { '<leader>lc', '<cmd>lua require("namespace.getClass").get()<cr>',   { desc = 'GetClass' } },
      { '<leader>la', '<cmd>lua require("namespace.getClasses").get()<cr>', { desc = 'GetClasses' } },
      { "<leader>lr", '<cmd>lua require("namespace.classAs").open()<cr>', { desc = 'ClassAs' } },
      { "<leader>ln", '<cmd>lua require("namespace.namespace").gen()<cr>', { desc = 'Generate Namespace' } },
    },
    dependencies = {
      "nvim-lua/plenary.nvim"
    }
  }
}
