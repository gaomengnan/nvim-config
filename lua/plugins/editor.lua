return {
  -- {
  --   "triglav/vim-visual-increment",
  -- },
  -- {
  --   "gelguy/wilder.nvim",
  --   config = function()
  --     -- config goes here
  --     require("wilder").setup({
  --       modes = {
  --         "/",
  --         "?",
  --         "=",
  --         ":",
  --       },
  --     })
  --   end,
  -- },
  { "michaeljsmith/vim-indent-object" },
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
      filesize = 2,
    },
    config = function(_, opts)
      require("bigfile").setup(opts)
    end,
  },
  { "wsdjeg/gfr.vim" },
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "xiyaowong/telescope-emoji.nvim",
    },
    keys = {
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "find plugin file",
      },
      {
        ";r",
        function()
          local builtin = require("telescope.builtin")
          builtin.oldfiles()
        end,
      },
      {
        ";f",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
      },
      {
        ";g",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep()
        end,
      },
      -- {
      --   "\\\\",
      --   function()
      --     local builtin = require("telescope.builtin")
      --     builtin.buffers()
      --   end,
      -- },
      {
        ";t",
        function()
          local builtin = require("telescope.builtin")
          builtin.help_tags()
        end,
      },
      {
        ";;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
      },
      {
        ";e",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
      },
      {
        ";q",
        function()
          local builtin = require("telescope.builtin")
          builtin.quickfix()
        end,
      },
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
      },
      {
        "sf",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = true,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions
      telescope.load_extension("emoji")
      -- telescope.load_extension("dap")

      -- local dap = require("dap")

      -- dap.adapters.php = {
      --   type = "executable",
      --   command = "node",
      --   args = { os.getenv("HOME") .. "/.config/vscode-php-debug/out/phpDebug.js" },
      -- }

      -- dap.configurations.php = {
      --   -- to run php right from the editor
      --   {
      --     name = "run current script",
      --     type = "php",
      --     request = "launch",
      --     port = 9003,
      --     cwd = "${fileDirname}",
      --     program = "${file}",
      --     runtimeExecutable = "php",
      --   },
      --   -- to listen to any php call
      --   {
      --     name = "listen for Xdebug local",
      --     type = "php",
      --     request = "launch",
      --     port = 9003,
      --   },
      --   -- to listen to php call in docker container
      --   -- {
      --   --   name = "listen for Xdebug docker",
      --   --   type = "php",
      --   --   request = "launch",
      --   --   port = 9000,
      --   --   -- this is where your file is in the container
      --   --   pathMappings = {
      --   --     ["/opt/project"] = "${workspaceFolder}",
      --   --   },
      --   -- },
      -- }

      -- opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      --   wrap_results = true,
      --   layout_strategy = "horizontal",
      --   layout_config = { prompt_position = "top" },
      --   sorting_strategy = "ascending",
      --   winblend = 0,
      --   mappings = {
      --     n = {},
      --   },
      -- })

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            ["n"] = {
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10, 1 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10, 1 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
      telescope.setup(opts)
      -- require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}
