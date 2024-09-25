return {
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = {
  --     {
  --       "nvim-lua/plenary.nvim",
  --     },
  --   },
  --   config = function(_, opts)
  --     local harpoon = require("harpoon")
  --     harpoon.setup(harpoon, opts)
  --     vim.keymap.set("n", "\\", function()
  --       harpoon.ui:toggle_quick_menu(harpoon:list())
  --     end, { desc = "Toggle harpoon menu" })
  --     vim.keymap.set("n", "\\s", function()
  --       harpoon:list():add()
  --     end, { desc = "Add harpoon file" })
  --     vim.keymap.set("n", "<leader>an", function()
  --       harpoon:list():next()
  --     end, { desc = "Toggle next buffer" })
  --     vim.keymap.set("n", "<leader>ap", function()
  --       harpoon:list():prev()
  --     end, { desc = "Toggle prev buffer" })
  --   end,
  -- },
  {
    "otavioschwanck/arrow.nvim",
    -- opts = {
    --   show_icons = true,
    --   leader_key = "\\", -- Recommended to be a single key
    -- },
    config = function()
      vim.keymap.set("n", "<leader>ap", require("arrow.persist").previous)
      vim.keymap.set("n", "<leader>an", require("arrow.persist").next)
      -- vim.keymap.set("n", "<leader>am", require("arrow.persist").toggle)
      require("arrow").setup({
        buffer_leader_key = "M",
        show_icons = true,
        always_show_path = true,
        leader_key = "\\", -- Recommended to be a single key
      })
    end,
  },
}
