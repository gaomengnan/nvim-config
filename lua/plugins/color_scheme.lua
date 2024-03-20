return {
  {
    "yorickpeterse/vim-paper",
  },
  {
    "Verf/deepwhite.nvim",
    lazy = false,
  },
  { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false },
  {
    "GustavoPrietoP/doom-themes.nvim",
  },
  {
    "romgrk/doom-one.vim",
  },
  {
    "rafi/awesome-vim-colorschemes",
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "nyoom-engineering/nyoom.nvim" },
  { "kepano/flexoki" },
  {
    "lunarvim/darkplus.nvim",
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  { "Abstract-IDE/Abstract-cs" },
  { "rebelot/kanagawa.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = false,
      styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
      },
      color_overrides = {
        mocha = {
          base = "#000000",
          mantle = "#000000",
          crust = "#000000",
        },
      },
      integrations = {
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        dropbar = {
          enabled = true,
          color_mode = true,
        },
      },
    },
  },
}
