return {
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
        beacon = {
          enable = false,
        },
        definition = {
          keys = {
            edit = "<C-c>e",
            vsplit = "<C-c>v",
            split = "<C-c>i",
          },
        },
        finder = {
          max_height = 1,
          keys = {
            edit = "<C-c>e",
            vsplit = "<C-c>v",
            split = "<C-c>i",
          },
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
}
