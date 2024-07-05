return {
  -- {
  --   "kndndrj/nvim-dbee",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   build = function()
  --     require("dbee").install()
  --   end,
  --   config = function()
  --     local pwd = "Root664@Yl"
  --     local encoded_pwd = string.gsub(pwd, "@", "@")
  --     local dev_url = "mysql://Yl_root:" .. encoded_pwd .. "@tcp(192.168.0.217:3306)/7815_db_3"
  --     require("dbee").setup({
  --       sources = {
  --         require("dbee.sources").MemorySource:new({
  --           {
  --             id = "dev",
  --             name = "dev",
  --             type = "mysql",
  --             url = dev_url,
  --           },
  --         }),
  --       },
  --     })
  --   end,
  -- },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      -- { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    -- cmd = {
    --   'DBUI',
    --   'DBUIToggle',
    --   'DBUIAddConnection',
    --   'DBUIFindBuffer',
    -- },
    init = function()
      local pwd = "Root664@Yl"
      local encoded_pwd = string.gsub(pwd, "@", "%%40")
      local dev_url = "mysql://Yl_root:" .. encoded_pwd .. "@192.168.0.217:3306/"
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_default_query = 'select * from "{table}" limit 10'
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.dbs = {
        dev = dev_url,
      }
    end,
  },
}
