return {
  -- { "sebdah/vim-delve" },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_inlay_hints = {
          enable = false,
        },
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  {
    "olexsmir/gopher.nvim",
    dependencies = { -- dependencies
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("gopher").setup({
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "~/go/bin/gotests", -- also you can set custom command path
          impl = "impl",
          iferr = "iferr",
        },
      })
    end,
  },
  {
    "fatih/vim-go",
    enabled = false,
    config = function()
      vim.g.go_gopls_enabled = 0
      vim.g.go_debug_substitute_paths = { {
        "/go/src/app",
        "/opt/wwwroot/go/Tracker_new",
      } }
      vim.g.go_gopls_options = {
        "/Users/wanglele/go/1.20.0/bin/gopls",
        "-remote=auto",
      }
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_code_completion_enabled = 0
    end,
  },
}
