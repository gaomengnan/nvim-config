return {
  {
    "willothy/veil.nvim",
    enabled = false,
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local currentTimestamp = os.time()
      local currentDateTable = os.date("*t", currentTimestamp)
      print(currentDateTable.wday)
      local weekdays = {
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
      }
      local currentWeekdayString = weekdays[currentDateTable.wday]
      local builtin = require("veil.builtin")
      require("veil").setup({
        sections = {
          builtin.sections.animated(builtin.headers.frames_days_of_week[currentWeekdayString], {
            hl = { fg = "#FFA500" },
          }),
          builtin.sections.buttons({
            {
              icon = "",
              text = "Find Files",
              shortcut = "f",
              callback = function()
                require("telescope.builtin").find_files()
              end,
            },
            {
              icon = "",
              text = "Find Word",
              shortcut = "g",
              callback = function()
                require("telescope.builtin").live_grep()
              end,
            },
          }),
          -- builtin.sections.oldfiles(),
        },
        mappings = {},
        startup = true,
        listed = false,
      })
    end,
  },
  { "mhinz/vim-startify" },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
    event = "VimEnter",
    opts = function()
      local logo = [[








      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",                                     desc = "  搜索",       icon = " ", key = "f" },
            { action = "ene | startinsert",                                        desc = "  新文件",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                                       desc = "  最近文件",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                                      desc = "  全文搜索",       icon = " ", key = "g" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = "  配置",          icon = " ", key = "c" },
            -- { action = 'lua require("persistence").load()',                        desc = "    Restore Session", icon = " ", key = "s" },
            -- { action = "LazyExtras",                                               desc = "    Lazy Extras",     icon = " ", key = "x" },
            -- { action = "Lazy",                                                     desc = "    Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                       desc = "  退出",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  -- {
  --   "CWood-sdf/spaceport.nvim",
  --   opts = {},
  --   lazy = false, -- load spaceport immediately
  -- },
}
