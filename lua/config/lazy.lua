local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        -- colorscheme = "xcode",
        -- colorscheme = "lightning",
        -- colorscheme = "molokai",
        -- colorscheme = "solarized-osaka",
        -- colorscheme = "doom-laserwave",
        -- colorscheme = "yellow-moon",
        -- colorscheme = "rigel",
        -- colorscheme = "oceanic_material",
        -- colorscheme = "falcon",
        -- colorscheme = "github",
        -- colorscheme = "tokyonight",
        -- colorscheme = "gotham",
        -- colorscheme = "aura",
        -- colorscheme = "molokayo",
        -- colorscheme = "purify",
        -- colorscheme = "sierra",
        -- colorscheme = "two-firewatch",
        -- colorscheme = "PaperColor",
        -- colorscheme = "paper",
        -- colorscheme = "deepwhite",
        -- colorscheme = "tender",
        -- colorscheme = "quite",
        -- colorscheme = "kanagawa-dragon",
        -- colorscheme = "oxocarbon",
        -- colorscheme = "ayu",
        -- colorscheme = "onehalflight",
        -- colorscheme = "onehaldark",
        -- colorscheme = "melange",
        -- colorscheme = "sorbet",
        -- colorscheme = "sonokai",
        -- colorscheme = "jellybeans",
        -- colorscheme = "doom-gruvbox-light",
        -- colorscheme = "nightfly",
        -- colorscheme = "spacecamp_lite",
        -- colorscheme = "focuspoint",
        -- colorscheme = "OceanicNext",
        -- colorscheme = "challenger_deep",
        -- colorscheme = "solarized8_flat",
        -- colorscheme = "jellybeans",
        -- colorscheme = "onehalflight",
        -- colorscheme = "twilight256",
        -- colorscheme = "slate",
        -- colorscheme = "lunaperche",
        -- colorscheme = "catppuccin-mocha",
        -- colorscheme = "catppuccin-latte",
        -- colorscheme = "zellner",
        -- colorscheme = "PaperColor",
        -- colorscheme = "doom-horizon",
        -- colorscheme = "doom-dracula",
        -- colorscheme = "doom-palenight",
        -- colorscheme = "abscs",
        -- colorscheme = "sunbather",
        -- colorscheme = "onedark_dark",
        colorscheme = "habamax",
      },
    },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.vscode" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
