return {
  -- {
  --   "ClzSkywalker/bloc.nvim",
  --   dependencies = {
  --     "nvimtools/none-ls.nvim",
  --   },
  -- },
  {
    "dart-lang/dart-vim-plugin",
  },
  -- {
  --   "natebosch/vim-lsc",
  -- },
  -- {
  --   "natebosch/vim-lsc-dart",
  -- },
  -- {
  --   "Nash0x7E2/awesome-flutter-snippets",
  -- },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional for vim.ui.select
      -- "mfussenegger/nvim-dap",
    },
    config = function()
      -- local keyset = vim.keymap.set
      -- local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
      --
      -- keyset("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)

      -- vim.g.dart_format_on_save = true
      require("flutter-tools").setup({
        -- decorations = {
        --   statusline = {
        --     -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
        --     -- this will show the current version of the flutter app from the pubspec.yaml file
        --     app_version = true,
        --     -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
        --     -- this will show the currently running device if an application was started with a specific
        --     -- device
        --     device = true,
        --     -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
        --     -- this will show the currently selected project configuration
        --     project_config = false,
        --   }
        -- },
        -- widget_guides = {
        --   enabled = true,
        -- },
        dev_log = {
          enabled = true,
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = "tabedit", -- command to use to open the log buffer
        },

        debugger = { -- integrate with nvim dap + install dart code debugger
          enabled = true,
          run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          -- exception_breakpoints = {},
          register_configurations = function(paths)
            require("dap").adapters.dart = {
              type = "executable",
              -- As of this writing, this functionality is open for review in https://github.com/flutter/flutter/pull/91802
              command = "flutter",
              args = { "debug_adapter" },
            }

            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter Program",
                -- The nvim-dap plugin populates this variable with the filename of the current buffer
                -- program = "${file}",
                -- The nvim-dap plugin populates this variable with the editor's current working directory
                -- cwd = "${workspaceFolder}",
                -- This gets forwarded to the Flutter CLI tool, substitute `linux` for whatever device you wish to launch
                -- toolArgs = {"-d", "linux"}
              },
              -- <put here config that you would find in .vscode/launch.json>
            }

            -- require("dap.config").load_launchjs();
          end,
        },
        lsp = {
          color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = true, -- highlight the background
            background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
            virtual_text_str = "■", -- the virtual text character to highlight
          },
          capabilities = function(config)
            config.specificThingIDontWant = false
            return config
          end,
          -- see the link below for details on each option:
          -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          },
        },
      })
    end,
  },
}
