return {
  { "arzg/vim-colors-xcode" },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("poimandres").setup({
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      })
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      vim.cmd("colorscheme poimandres")
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  { "techtuner/aura-neovim" },
  { "fenetikm/falcon" },
  { "sheerun/vim-polyglot" },
  { "Rigellute/rigel" },
  { "NLKNguyen/papercolor-theme" },
  { "savq/melange-nvim", lazy = false },
  { "cormacrelf/vim-colors-github" },
  {
    "bruth/vim-newsprint-theme",
  },
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
  { "rebelot/kanagawa.nvim" },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      term_colors = true,
      transparent_background = true,
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

  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },
  {
    "overvale/vacme"
  }
}
