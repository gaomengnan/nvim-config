return {
  "nvimdev/lspsaga.nvim",
  config = function()
    require("lspsaga").setup({
      finder = {
        max_height = 1,
        keys = {
          edit = '<C-c>o',
          vsplit = '<C-c>v',
          split = '<C-c>i',
        }
      }
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
}
