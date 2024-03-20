local Util = require("lazyvim.util")
return {
  {
    "nvim-neotest/nvim-nio",
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     {
  --       "Saecki/crates.nvim",
  --       event = { "BufRead Cargo.toml" },
  --       opts = {
  --         src = {
  --           cmp = { enabled = true },
  --         },
  --       },
  --     },
  --   },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
  --       { name = "crates" },
  --     }))
  --   end,
  -- },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-emoji" },
      -- {"onsails/lspkind.nvim"},
      -- {
      --   "tzachar/cmp-tabnine",
      --   build = "./dl_binaries.sh",
      --   dependencies = "hrsh7th/nvim-cmp",
      --   opts = {
      --     max_lines = 1000,
      --     max_num_results = 2,
      --     sort = true,
      --   },
      --   config = function(_, opts)
      --     require("cmp_tabnine.config"):setup(opts)
      --   end,
      -- },
    },

    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- table.insert(opts.sources, 1, {
      --   name = "cody",
      --   priority = 200,
      -- })
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))

      table.insert(opts.sources, 1, {
        name = "codeium",
        group_index = 1,
        priority = 100,
      })

      -- table.insert(opts.sources, 2, {
      --   name = "cmp_tabnine",
      --   group_index = 1,
      --   -- priority = 100,
      -- })

      opts.formatting.format = Util.inject.args(opts.formatting.format, function(entry, item)
        -- require("lspkind").cmp_format({
        --   mode = "symbol",
        --   maxwidth = 50,
        --   ellipsis_char = "...",
        --   symbol_map = { Codeium = "" },
        -- })
        -- Hide percentage in the menu
        -- if entry.source.name == "cmp_tabnine" then
        --   item.menu = ""
        -- end
      end)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",

    dependencies = {

      -- fancy UI for the debugger
      {
        "rcarriga/nvim-dap-ui",
        -- stylua: ignore
        keys = {
          { "<leader>du", function()   require("dapui").toggle({})
          end, desc = "Dap UI" },
          { "<leader>de", function()   require("dapui").eval()
          end, desc = "Eval", mode = {"n", "v"} },
        },
        opts = {},
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },

      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      -- which key integration
      {
        "folke/which-key.nvim",
        optional = true,
        opts = {
          defaults = {
            ["<leader>d"] = { name = "+debug" },
          },
        },
      },

      -- mason.nvim integration
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
          },
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function()   require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, desc = "Breakpoint Condition" },
      { "<leader>db", function()   require("dap").toggle_breakpoint()
      end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function()   require("dap").continue()
      end, desc = "Continue" },
      { "<leader>da", function()   require("dap").continue({ before = get_args })
      end, desc = "Run with Args" },
      { "<leader>dC", function()   require("dap").run_to_cursor()
      end, desc = "Run to Cursor" },
      { "<leader>dg", function()   require("dap").goto_()
      end, desc = "Go to line (no execute)" },
      { "<leader>di", function()   require("dap").step_into()
      end, desc = "Step Into" },
      { "<leader>dj", function()   require("dap").down()
      end, desc = "Down" },
      { "<leader>dk", function()   require("dap").up()
      end, desc = "Up" },
      { "<leader>dl", function()   require("dap").run_last()
      end, desc = "Run Last" },
      { "<leader>do", function()   require("dap").step_out()
      end, desc = "Step Out" },
      { "<leader>dO", function()   require("dap").step_over()
      end, desc = "Step Over" },
      { "<leader>dp", function()   require("dap").pause()
      end, desc = "Pause" },
      { "<leader>dr", function()   require("dap").repl.toggle()
      end, desc = "Toggle REPL" },
      { "<leader>ds", function()   require("dap").session()
      end, desc = "Session" },
      { "<leader>dt", function()   require("dap").terminate()
      end, desc = "Terminate" },
      { "<leader>dw", function()   require("dap.ui.widgets").hover()
      end, desc = "Widgets" },
    },

    config = function()
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",

    -- stylua: ignore
    keys = {
      { "<leader>du", function()   require("dapui").toggle({})
      end, desc = "Dap UI" },
      { "<leader>de", function()   require("dapui").eval()
      end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      -- setup dap config by VsCode launch.json file
      -- require("dap.ext.vscode").load_launchjs()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",

    opts = {},
  },
  {
    "jay-babu/mason-nvim-dap.nvim",

    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  {
    "folke/which-key.nvim",

    optional = true,
    opts = {
      defaults = {
        ["<leader>d"] = { name = "+debug" },
      },
    },
  },
  {
    "williamboman/mason.nvim",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "luacheck",
        "goimports",
        "gofumpt",
        "gomodifytags",
        "impl",
        "delve",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
        "rust",
        "ron",
        "toml",
        "php",
        "python",
        "c",
        "cpp",
        -- "hpp",
        -- "dart",
        -- "dart"
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        -- Ensure mason installs the server
        -- dartls = {
        --   setup = {
        --     cmd = { "dart", "language-server", "--protocol=lsp" },
        --   },
        -- },
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

        pyright = {},

        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
          },
        },
        rust_analyzer = {
          keys = {
            { "K", "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
            { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code Action (Rust)" },
            { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
          },
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          -- cmd = {
          --   "/Users/wanglele/go/1.20.0/bin/gopls",
          --   "-remote=auto",
          --   -- "-listen=unix;/var/folders/1r/r0yhk_2d01q1qsvc7h0lchf40000gn/T/gopls-915cd1-daemon.wanglele1",
          -- },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,

        ruff_lsp = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,

        rust_analyzer = function(_, opts)
          local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
          return true
        end,
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "gopls" then
              -- client.server_capabilities.documentFormattingProvider = false
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,
      },
    },
  },

  {

    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "8816",
            request = "launch",
            program = "${file}",
            cwd = "${relativeFileDirname}",
            args = { "server", "-c=./tracker/config/settings.tracker8816.yml" },
          },
        },
      })
    end,
  },
}
